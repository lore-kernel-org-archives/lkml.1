Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbYKET0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbYKET0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 14:26:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755884AbYKET0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 14:26:34 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:60997 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514AbYKET0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 14:26:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=cS5nN5XLXwQrankGylc7IrqE+X4R4TiFSqLkM0s5bM2dU7eblqOQQmJraeyTmaSKmE
         M9J3RrgyXpsL7L0Uf2TqEg3/L9SwZWZuduyQ5fdI1Lna8hP0obcttA0746ptN9MByL+w
         nLKcJn6hyyXqSgt7k1peNM8RVgWdSg8DFrOGo=
Message-ID: <4911F363.1070208@gmail.com>
Date: Wed, 05 Nov 2008 20:26:27 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Vincent Hanquez <tab@snarc.org>
CC: Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Henrik Rydberg <rydberg@euromail.se>
Subject: Re: [PATCH] hid update for macbook brick fn key
References: <20081105190143.GA4529@snarc.org>
In-Reply-To: <20081105190143.GA4529@snarc.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2008 08:01 PM, Vincent Hanquez wrote:
> The following patch add support for late 2008 macbook (apparently
> codename 'brick') keyboard that was missing the fn key behavior.

Unfortunately similar patch was already sent by Henrik few days ago:
http://lkml.org/lkml/2008/11/4/331


