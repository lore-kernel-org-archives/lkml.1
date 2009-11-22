Return-Path: <linux-kernel-owner+w=401wt.eu-S1752133AbZKVHF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbZKVHF2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 02:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbZKVHF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 02:05:27 -0500
Received: from mailout-apollo.uni-duesseldorf.de ([134.99.128.36]:49162 "EHLO
	mail.rz.uni-duesseldorf.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750827AbZKVHF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 02:05:26 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Sun, 22 Nov 2009 08:05:30 +0100 (CET)
From: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Subject: Re: TIF_NOTIFY_RESUME on m68k?
In-reply-to: <19205.28811.911525.832480@pilspetsen.it.uu.se>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       linux-m68k <linux-m68k@vger.kernel.org>,
       uClinux development list <uclinux-dev@uclinux.org>,
       linux-kernel@vger.kernel.org
Message-id: <alpine.DEB.2.00.0911220800520.11826@zirkon.biophys.uni-duesseldorf.de>
References: <10f740e80911181202l6cca6b41m827f2c51f639d1f0@mail.gmail.com>
 <19205.28811.911525.832480@pilspetsen.it.uu.se>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Do current 2.6.3x m68k kernels boot on aranym? Last time I tried aranym
> it could only boot som ancient hacked 2.4 kernel, for 2.6 kernels I got
> disk detection errors due to what looked like byteswapping issues.

Your disk image may need byte swapping (there should be an ARAnyM option for 
this). 2.4 probably still could byte-swap IDE disks on Atari, 2.6 cannot.

	Michael

