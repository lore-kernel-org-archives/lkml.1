Return-Path: <linux-kernel-owner+w=401wt.eu-S1763632AbYBMP2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763632AbYBMP2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756292AbYBMP2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:28:30 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:45336 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078AbYBMP23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:28:29 -0500
Date: Wed, 13 Feb 2008 10:28:22 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: list of references to non-existent include/linux headers
Message-ID: <alpine.LFD.1.00.0802131027070.30845@localhost.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
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


  as the last scan of the day, here's a list of includes of the form

  #include <linux/fubar.h>

for which there is no such include/linux/fubar.h header file.

http://www.crashcourse.ca/wiki/index.php/Badref_linux_header_files

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
