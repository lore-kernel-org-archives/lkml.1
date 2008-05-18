Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbYERK7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbYERK7i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 06:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbYERK71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 06:59:27 -0400
Received: from mail.gmx.net ([213.165.64.20]:54351 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752549AbYERK7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 06:59:11 -0400
X-Authenticated: #428038
X-Provags-ID: V01U2FsdGVkX19ThKsswG1TVHtOHYIw2nC9S3S5anG+dIEIUHiYMH
	vy0wU177dp80qT
Date: Sun, 18 May 2008 12:59:06 +0200
From: Matthias Andree <matthias.andree@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses of
	IRQF_SAMPLE_RANDOM
Message-ID: <20080518105906.GC9845@merlin.emma.line.org>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <482C7B18.6060003@garzik.org> <482C7E53.3050300@hp.com> <482C8184.2030906@garzik.org> <482C8550.5000909@intel.com> <482C8D4D.3040702@garzik.org> <20080516132107.GA11304@csclub.uwaterloo.ca> <20080516161029.44ded734@core> <20080516173610.GA27126@csclub.uwaterloo.ca> <20080516191125.46f59ad6@core> <482DD50C.2070601@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482DD50C.2070601@intel.com>
X-PGP-Key: http://home.pages.de/~mandree/keys/GPGKEY.asc
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2008, Kok, Auke wrote:

> I remember Jesse telling that he had this very same experience while installing a
> RH box on a headless system with a serial console - a box prompted the user to
> rattle a keyboard in order for the ssh key generation to continue :)
> 
> you absolutely don't want to use urandom for that I assume, but if the system just
> sits dead waiting for randomness, and you can't see the popup asking for some
> entropy, you're pretty much screwed :)

If the distro goofs up the headless installation mode, what is the
kernel's part of the fault? I see none.

-- 
Matthias Andree
