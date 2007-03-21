Return-Path: <linux-kernel-owner+w=401wt.eu-S1751668AbXCUIWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbXCUIWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 04:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbXCUIWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 04:22:52 -0400
Received: from webmail.woosh.co.nz ([202.74.207.2]:4755 "EHLO
	mail2.woosh.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbXCUIWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 04:22:50 -0400
Date: Wed, 21 Mar 2007 20:22:44 +1200 (NZST)
From: Keith Duthie <keith@no.net.nz>
To: linux-kernel@vger.kernel.org
cc: Willy Tarreau <w@1wt.eu>, Xavier Bestel <xavier.bestel@free.fr>,
       Mark Lord <lkml@rtr.ca>, Al Boldi <a1426z@gawab.com>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Ingo Molnar <mingo@elte.hu>, Nicholas Miell <nmiell@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: RSDL v0.31
In-Reply-To: <Pine.LNX.4.64.0703200821420.6730@woody.linux-foundation.org>
Message-ID: <alpine.DEB.0.83.0703212016420.6116@sleipnir.no.net.nz>
References: <200703042335.26785.a1426z@gawab.com> <200703172048.46267.kernel@kolivas.org>
 <1174125534.7734.2.camel@Homer.simpson.net> <200703172355.30989.a1426z@gawab.com>
 <45FEB54A.3040602@rtr.ca> <1174321617.30876.69.camel@frg-rhel40-em64t-04>
 <45FEBBF5.9060002@rtr.ca> <1174322580.30876.72.camel@frg-rhel40-em64t-04>
 <Pine.LNX.4.64.0703192006130.6730@woody.linux-foundation.org>
 <20070320061152.GW943@1wt.eu>
 <Pine.LNX.4.64.0703200821420.6730@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Another data point: I'm getting stalls in mplayer. I'm assuming the stalls
occur when procmail runs messages through spamprobe, as the system is
otherwise idle. The stalls continue to occur (and I'm not sure that they
aren't worse) when X and/or mplayer are reniced to negative nice levels.

This is on a dual core amd64 system running 2.6.20.3 with rsdl 0.31.
Admittedly I'm also running the nvidia binary driver with X.

-- 
The universe hates you, but don't worry - it's nothing personal.
