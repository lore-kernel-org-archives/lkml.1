Return-Path: <linux-kernel-owner+w=401wt.eu-S1762180AbZLPOnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762180AbZLPOnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 09:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758102AbZLPOnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 09:43:16 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:45943 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787AbZLPOnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 09:43:14 -0500
Date: Wed, 16 Dec 2009 09:42:50 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: anyone including <linux/perf_counter.h>?
Message-ID: <alpine.LFD.2.00.0912160939510.7588@localhost>
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


  just prepping to run my cleanup suggestion scripts after the merge
window closes, quick test run on some scripts and ran across the fact
that no one appears to be including <linux/perf_counter.h>.

  any value to that file?  just curious.  much more pedantry after the
merge window, of course.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
