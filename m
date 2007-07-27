Return-Path: <linux-kernel-owner+w=401wt.eu-S1765380AbXG0H1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765380AbXG0H1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 03:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbXG0H1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 03:27:44 -0400
Received: from smtp2a.orange.fr ([80.12.242.140]:29275 "EHLO smtp2a.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbXG0H1n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 03:27:43 -0400
X-ME-UUID: 20070727072742662.A1B537000087@mwinf2a21.orange.fr
From: David CHANIAL <david.ml@euro-web.fr>
Organization: Euro Web
To: "Linux Kernel Mailinglist" <linux-kernel@vger.kernel.org>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference - nfs v3
Date: Fri, 27 Jul 2007 09:28:27 +0200
User-Agent: KMail/1.9.5
Cc: "Satyam Sharma" <satyam.sharma@gmail.com>, "Neil Brown" <neilb@suse.de>
References: <200707160638.15750.david.ml@euro-web.fr> <200707201533.14517.david.ml@euro-web.fr> <a781481a0707200636s353c8a64l5564d5f81cc7f266@mail.gmail.com>
In-Reply-To: <a781481a0707200636s353c8a64l5564d5f81cc7f266@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707270928.27328.david.ml@euro-web.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 20 juillet 2007 15:36, Satyam Sharma a écrit :
> Yes, you can apply the patch Neil just sent to your kernel,
> re-build, and test that.

Hi, I have no patched the kernel as asked by Neil, but i would notice that 
with 2.6.22.1 kernel it continue to happend :

http://internetworkpro.org/pastebin/765

I would patch the kernel now and wait to see...

Best regards,
-- 
David

