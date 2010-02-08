Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab0BHOjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 09:39:10 -0500
Received: from mail.gmx.net ([213.165.64.20]:48443 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752695Ab0BHOjG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 09:39:06 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18yiNk0hxcy9D14Mk+2QY/KmpTLcGFQM7yvu2mlrP
	V3tegueIFxEs75
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #15100] X11 is black after resume from s2ram if my T400 was previous in docking station before
Date: Mon, 8 Feb 2010 15:38:59 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.31.12; KDE/4.3.5; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Eric Anholt" <eric@anholt.net>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Matthew Garrett" <mjg@redhat.com>
References: <2uzMDuY-7_O.A.M1G.7X1bLB@chimera> <201002080952.55900.toralf.foerster@gmx.de> <201002081158.36284.rjw@sisk.pl>
In-Reply-To: <201002081158.36284.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201002081538.59453.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.66000000000000003
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Rafael J. Wysocki wrote at 11:58:36
> I wonder if the patch from http://bugzilla.kernel.org/show_bug.cgi?id=15000
> helps?
> 
> Rafael
> 
No, tested patch against 2.6.32.8-rc2 and current git (-rc7) - no success.

BTW the mentioned commit fe06fba29 of bug #15000 is 1 month younger than the 
first bad commit c1c7af608 of bug #15100.

-- 
MfG/Sincerely
Toralf Förster
