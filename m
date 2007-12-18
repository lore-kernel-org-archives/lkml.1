Return-Path: <linux-kernel-owner+w=401wt.eu-S1764243AbXLRSWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764243AbXLRSWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 13:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759312AbXLRSVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 13:21:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763265AbXLRSVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 13:21:04 -0500
Date: Tue, 18 Dec 2007 13:19:39 -0500 (EST)
From: Chip Coldwell <coldwell@redhat.com>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
cc: - ARM Linux <linux@arm.linux.org.uk>, Russell@frank.harvard.edu,
       kernel@avr32linux.org, linux-kernel@vger.kernel.org,
       Andrew Victor <linux@maxim.org.za>, Remy Bohmer <linux@bohmer.net>,
       ARM@frank.harvard.edu,
       Linux Mailing List <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH 4/5] atmel_serial: Split the interrupt handler
In-Reply-To: <20071218181019.2af46418@dhcp-252-066.norway.atmel.com>
Message-ID: <alpine.LFD.0.9999.0712181318300.27475@localhost.localdomain>
References: <1197997575-13292-1-git-send-email-hskinnemoen@atmel.com> <1197997575-13292-2-git-send-email-hskinnemoen@atmel.com> <1197997575-13292-3-git-send-email-hskinnemoen@atmel.com> <1197997575-13292-4-git-send-email-hskinnemoen@atmel.com>
 <1197997575-13292-5-git-send-email-hskinnemoen@atmel.com> <20071218181019.2af46418@dhcp-252-066.norway.atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Tue, 18 Dec 2007, Haavard Skinnemoen wrote:

> On Tue, 18 Dec 2007 18:06:14 +0100
> Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> 
> > From: Remy Bohmer <hskinnemoen@atmel.com>
> 
> Heh. That's obviously wrong. Wonder what happened there?
> 
> Looks like Chip's address got mangled too.

You can find me at <coldwell@gmail.com> or <coldwell@redhat.com> these
days, although <coldwell@frank.harvard.edu> still works for the time
being.

Chip

- -- 
Charles M. "Chip" Coldwell
Senior Software Engineer
Red Hat, Inc
978-392-2426

GPG ID:  852E052F
GPG FPR: 77E5 2B51 4907 F08A 7E92  DE80 AFA9 9A8F 852E 052F
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHaA87r6maj4UuBS8RApaiAKCDFvC/WtA/s0pysvMIZIsTlAcN7wCffRoa
JwA3E6Kt16pU9yi1dx1lCWk=
=M528
-----END PGP SIGNATURE-----
