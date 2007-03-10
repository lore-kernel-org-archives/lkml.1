Return-Path: <linux-kernel-owner+w=401wt.eu-S1751193AbXCJTEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751193AbXCJTEz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 14:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbXCJTEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 14:04:55 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:39006 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbXCJTEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 14:04:54 -0500
Date: Sat, 10 Mar 2007 20:04:38 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: "Make nenuconfig" does not save parameters.
In-Reply-To: <20070310185029.GA20131@cvg>
Message-ID: <Pine.LNX.4.61.0703102003500.23298@yvahk01.tjqt.qr>
References: <20070310160542.21cdb968@localhost> <20070310160614.GB10230@cvg>
 <Pine.LNX.4.61.0703101724160.8799@yvahk01.tjqt.qr> <20070310194617.2aef1006@localhost>
 <Pine.LNX.4.61.0703101747530.8799@yvahk01.tjqt.qr> <20070310175058.GA19878@cvg>
 <Pine.LNX.4.61.0703101906070.8799@yvahk01.tjqt.qr> <20070310185029.GA20131@cvg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 10 2007 21:50, Cyrill Gorcunov wrote:
>
>Actually, I always work with only .config file too... and the reason I
>wrote you is Vladimir's mail... so either menuconfig does not work as
>expected or users does not expect a such behaviour of menuconfig.

The latter. Though this behavior has been there since... I think since
menuconfig came into existence. It goes way back to 2.4 and 2.2.


Jan
-- 
