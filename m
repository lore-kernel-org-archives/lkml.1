Return-Path: <linux-kernel-owner+w=401wt.eu-S1760328AbZFMNMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760328AbZFMNMD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 09:12:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757501AbZFMNLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 09:11:55 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:49616 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597AbZFMNLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 09:11:54 -0400
Date: Sat, 13 Jun 2009 09:10:03 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: the right time to run my super-duper, kernel cleanup scripts?
Message-ID: <alpine.LFD.2.00.0906130907070.4074@localhost>
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


  i figure it's almost time to annoy the crap out of everyone again by
running my standard source "cleanup" scripts to track down things
like, well, this:

http://www.crashcourse.ca/wiki/index.php/Kernel_cleanup

  i'm thinking that the right time is after the chaos of the merge
window is mostly over so ... once rc1 is out?  is that about the right
time to give any fixes a chance to settle?

rday

p.s.  given that most of my scripts are simple variations of one
another and share a bunch of common code, it would probably be simple
to tweak them to look for other stuff, if anyone wants to suggest it.

--


========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
