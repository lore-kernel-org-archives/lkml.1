Return-Path: <linux-kernel-owner+w=401wt.eu-S1757091AbZALVbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091AbZALVbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 16:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbZALVbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 16:31:08 -0500
Received: from rn-out-0910.google.com ([64.233.170.187]:16761 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbZALVbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 16:31:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=a90N0nXLikqwecLir7gQgFbox2ZLt3ogYLcLV/UZAyEn7AonyHEqI+Lp0Yqb1XVcIz
         vNtQ/xkWHthCuBVgy79mhEpo2+KJle7CsJ3U2aswz4J42XrthH93MzFl1YnINIS1OnEP
         mcwWcFiXcCvXLknz1bxmTR3wVj2jo8eu1Nats=
Subject: Re: Can we get warnings from the x86 userspace headers fixed?
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090112212855.GB15185@uranus.ravnborg.org>
References: <20090112212855.GB15185@uranus.ravnborg.org>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 13:31:03 -0800
Message-Id: <1231795863.5405.8.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-12 at 22:28 +0100, Sam Ravnborg wrote:
> Hi Ingo.
> 
> We have recently introduced a lot of new warnings for our
> userspace headers.
> 
> Try to do a "make headers_check" and enjoy...
> 
> Are there any chance you could ask one of your helpers to
> start to look into the x86 specific ones?
> 
> If we get x86 clean this would create more incentive to
> make the generic clean too.
> 
> I had originally planned to attack the generic headers
> (include/linux/*) but I'm faced by reality after my
> vacation and has almost no spare time for the time being.
> 
> I already fixed the sparc headers but that is not 
> visible compared to x86 (the fixes was btw easy).
> 
> I can try to help by doing a few reviews in the
> beginning but I need to fix kbuild stuff first where
> I have a few serious issues pending. And lacks time...
> 

I'll have a go at some of them this afternoon unless someone beats me to it.

Harvey


