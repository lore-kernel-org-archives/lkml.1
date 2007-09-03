Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193AbXICXmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbXICXmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 19:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbXICXms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 19:42:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33611 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbXICXmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 19:42:47 -0400
Date: Tue, 4 Sep 2007 05:25:57 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: David CHANIAL <david.ml@euro-web.fr>
cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference - nfs v3
In-Reply-To: <200707270928.27328.david.ml@euro-web.fr>
Message-ID: <alpine.LFD.0.999.0709040521170.8504@enigma.security.iitk.ac.in>
References: <200707160638.15750.david.ml@euro-web.fr> <200707201533.14517.david.ml@euro-web.fr>
 <a781481a0707200636s353c8a64l5564d5f81cc7f266@mail.gmail.com>
 <200707270928.27328.david.ml@euro-web.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,


On Fri, 27 Jul 2007, David CHANIAL wrote:
> 
> Le vendredi 20 juillet 2007 15:36, Satyam Sharma a ecrit:
> > Yes, you can apply the patch Neil just sent to your kernel,
> > re-build, and test that.
> 
> Hi, I have no patched the kernel as asked by Neil, but i would notice
> that
> with 2.6.22.1 kernel it continue to happend :
> 
> http://internetworkpro.org/pastebin/765
> 
> I would patch the kernel now and wait to see...

Did you test with that patch applied? Did you manage to hit the
BUG again (with or without it)?

Neil, I don't see this one applied upstream as yet -- if this patch
indeed solves the oops David saw again (as per the link he has posted)
then I'd suggest it be pushed upstream (and -stable too).


Satyam
