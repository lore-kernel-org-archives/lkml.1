Return-Path: <linux-kernel-owner+w=401wt.eu-S1755235AbXKDRdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbXKDRdM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 12:33:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbXKDRc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 12:32:59 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:59210 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbXKDRc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 12:32:58 -0500
Date: Sun, 4 Nov 2007 12:31:38 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: duplicated include files
Message-ID: <Pine.LNX.4.64.0711041229580.27153@localhost.localdomain>
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
X-Mailing-List: linux-kernel@vger.kernel.org


  given the recent patches to remove duplicated #include preprocessor
directives in source files, let it be known that there are a number of
them:

  http://www.crashcourse.ca/wiki/index.php/Duplicate_include_files

help yourself.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
