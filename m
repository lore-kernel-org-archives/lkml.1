Return-Path: <linux-kernel-owner+w=401wt.eu-S933952AbYEUNtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933952AbYEUNtB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 09:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933923AbYEUNsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 09:48:36 -0400
Received: from po-out-1718.google.com ([72.14.252.158]:20143 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933514AbYEUNsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 09:48:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=s7QF7Nb09eOQQ6PAWZwvtYX9N6Y4BcMgfGPeXUPysYQDkXmAJhZ4rW2IGm8buiqN73X3c3sv3VzsOAoICe4ImC7eUDnJmxZubzjD6MqFAcy7i1ozdIfCtOmakCa0sDRaNS0zqjHB67OvL3+4WC9xQw6tuXOvxVKzjxPu1dewsA0=
Message-ID: <84144f020805210648y43efb024w8e2f28e62894b1d@mail.gmail.com>
Date: Wed, 21 May 2008 16:48:34 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: Suggestion About Kernel Releases
Cc: "Tarkan Erimer" <tarkan@netone.net.tr>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080521063855.0bdb441c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48341ED5.7060508@netone.net.tr>
	 <20080521063855.0bdb441c@infradead.org>
X-Google-Sender-Auth: b3fbc336e1f5afc4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 16:08:37 +0300, Tarkan Erimer <tarkan@netone.net.tr> wrote:
>> After long discussions about kernel release methodology, an idea has
>> came to ( Any comments welcomed :-) ) my mind :

On Wed, May 21, 2008 at 4:38 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> what would you want to accomplish with your idea?

And how is it different from what we do now, modulo the -test1 postfix
to the name?
