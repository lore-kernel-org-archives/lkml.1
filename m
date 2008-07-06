Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbYGFADS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbYGFADS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 20:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088AbYGFADD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 20:03:03 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:47312 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbYGFADB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 20:03:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=dWKhUhe8p5lXkMaUVTzJO7lb6jg4sW6DmXr+2NmXaJvQtolTIldzuuYqfkNHqZgbAs
         A7RjR365rm8zutMlNPrLxlSO9HjG2lzzQV+/fEfBOCypCbQFEoRBI9zNoVzryYu5jqYz
         xwWWiDsLPnJPApHpNpVKDw0sYIVrjgqjpCULM=
Message-ID: <84144f020807051702q1fc6275cv358c5e33dc2677fc@mail.gmail.com>
Date: Sun, 6 Jul 2008 03:02:59 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: the printk problem
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jan Engelhardt" <jengelh@medozas.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Peter Anvin" <hpa@zytor.com>, "David S. Miller" <davem@davemloft.net>,
       linux-ia64@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080705185253.GQ14894@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080705125230.GA20166@damson.getinternet.no>
	 <alpine.LFD.1.10.0807051045520.2815@woody.linux-foundation.org>
	 <19f34abd0807051141h4ccfd0ar28660199f2bbf81f@mail.gmail.com>
	 <20080705185253.GQ14894@parisc-linux.org>
X-Google-Sender-Auth: c0efb8884005ba6a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2008 at 08:41:39PM +0200, Vegard Nossum wrote:
>> Single letters are bad because it hurts readability and limits the
>> usefulness of the extension.</MHO>

On Sat, Jul 5, 2008 at 9:52 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> I think you need a little warning noise that goes off in your head that
> means "I might be overdesigning this".  Linus' code is elegant and
> solves a problem nicely.

Am I the only one who missed Linus' patch? Did it make it to the list?
