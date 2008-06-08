Return-Path: <linux-kernel-owner+w=401wt.eu-S1757732AbYFHWaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732AbYFHWaz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 18:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbYFHWaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 18:30:46 -0400
Received: from smtps.uol.com.br ([200.221.4.131]:50426 "EHLO smtp.uol.com.br"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752780AbYFHWap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 18:30:45 -0400
Date: Sun, 8 Jun 2008 19:30:41 -0300
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.26-rc4] Problems with rt2x00 USB interface on powerpc
Message-ID: <20080608223041.GB22242@ime.usp.br>
References: <20080601193000.GA3056@ime.usp.br> <200806081242.54896.IvDoorn@gmail.com> <20080608213513.GA30499@ime.usp.br> <200806090002.17938.IvDoorn@gmail.com> <20080608220934.GA22242@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080608220934.GA22242@ime.usp.br>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SIG5: 51095daebfc535e04ce9ab0a1f5d0e9f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again, Ivo.

On Jun 08 2008, Rogério Brito wrote:
> On Jun 09 2008, Ivo van Doorn wrote:
> > However I just realized I had a D-Link stick myself, and apparently
> > I have the exact same model/type. I'll compile a 2.6.26-rc5 kernel
> > and see if that stick works for me, if so, I have the working
> > register dump. And if not, then we can rule out endian problems.

I just observed one thing: with a 2.6.26-rc5 kernel, I always get
"Access Point: Not-Associated" with that script that I sent you
earlier.  On the other hand, with 2.6.26-rc4, I can actually associate
to the AP (i.e., I see its MAC address).

I may have changed some parameters for the kernel compilation between
the two of them. I will see if I can reproduce the problem with the same
.config file for the kernel.


Thanks, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
