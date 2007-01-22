Return-Path: <linux-kernel-owner+w=401wt.eu-S1751707AbXAVV2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbXAVV2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 16:28:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbXAVV2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 16:28:14 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:47738 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbXAVV2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 16:28:13 -0500
Date: Mon, 22 Jan 2007 22:22:54 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
cc: Eduard Bloch <edi@gmx.de>, Bodo Eggert <7eggert@gmx.de>,
       Tony Foiani <tkil@scrye.com>,
       Leon Woestenberg <leon.woestenberg@gmail.com>,
       linux-kernel@vger.kernel.org, David Schwartz <davids@webmaster.com>
Subject: Re: PROBLEM: KB->KiB, MB -> MiB, ... (IEC 60027-2)
In-Reply-To: <20070122204326.GA7582@csclub.uwaterloo.ca>
Message-ID: <Pine.LNX.4.61.0701222221530.317@yvahk01.tjqt.qr>
References: <7FsPf-51s-9@gated-at.bofh.it> <7FxlV-3sb-1@gated-at.bofh.it>
 <7FyUF-5XD-21@gated-at.bofh.it> <E1H8a7s-0000at-Jx@be1.lrz>
 <20070121111000.GA6679@rotes76.wohnheim.uni-kl.de> <20070122155354.GB25916@csclub.uwaterloo.ca>
 <Pine.LNX.4.61.0701221756000.317@yvahk01.tjqt.qr> <20070122204326.GA7582@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 22 2007 15:43, Lennart Sorensen wrote:
>
>On Mon, Jan 22, 2007 at 05:58:42PM +0100, Jan Engelhardt wrote:
>> For "F"s sake, when you gotta use abbreviations, then just use k=1000 and
>> K=1024 already, b for bits and B for bytes. Problem gone.
>
>And for 10^6 vs 2^20?

"My harddisk is a 251 gB" actually even though it is advertised as 250 GB.


	-`J'
-- 
