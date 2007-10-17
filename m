Return-Path: <linux-kernel-owner+w=401wt.eu-S936058AbXJQDK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936058AbXJQDK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 23:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760894AbXJQDKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 23:10:48 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:22816 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760103AbXJQDKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 23:10:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=b7diE91RlyzlzlgO/TDunCXGaQy9ptf7jrPEsFxPRnKgP4DHzZ3zvNT8FP6CL+57m41hTqXijweAkfhPxOWorcbLO5Cfkf6QXEd5+SJsewjB9Sr7vjfL5IcQ3dpLsSfhNKRS63j3CKS+W/3c6SWIUViXGtdQhs2SkStfDw9qL/k=
Message-ID: <47157C4B.2000502@googlemail.com>
Date: Wed, 17 Oct 2007 05:06:51 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: Chris Holvenstot <cholvenstot@comcast.net>
CC: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Boot Failure with 2.6.23-rc10
References: <1192589191.6732.11.camel@localhost>
In-Reply-To: <1192589191.6732.11.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Holvenstot wrote:
> Greetings - 

Hi,

> 
> This is likely something I am doing wrong (or stupid) but I have run
> through the build process a couple of times with the same result.  
> 
> When booted, the following messages are displayed:
> 
> Linux  zimage kernel to big, try "make bzImage"
> 
> Error 28: Selected item can into fit into memory
> 
> I have tried the "make bzImage" and manually copied forward to /boot -
> no joy.
> 

If you use git just pull is already fixed if not get that patch :

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=7eebb9348655b55553d65fc7cb6cfad292d28dbb


Regards,

Gabriel
