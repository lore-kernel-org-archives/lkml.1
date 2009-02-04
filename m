Return-Path: <linux-kernel-owner+w=401wt.eu-S1760408AbZBDVms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760408AbZBDVms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 16:42:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbZBDVmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 16:42:39 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:55873 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126AbZBDVmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 16:42:38 -0500
Date: Wed, 4 Feb 2009 16:41:54 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: can i replace a 2.6.10 gen_init_cpio.c with a current one?
Message-ID: <alpine.LFD.2.00.0902041640050.8176@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  i'm currently stuck with a 2.6.10 kernel on a current project, and i
would like to build an initramfs with symlinks.  the gen_init_cpio.c
program back then didn't support "slink", but the new one does.  am i
safe to simply replace that program?  are there any backward
incompatibilities that will bite me in the a$$?

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
