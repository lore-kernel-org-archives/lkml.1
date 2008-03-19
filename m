Return-Path: <linux-kernel-owner+w=401wt.eu-S934857AbYCSUrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934857AbYCSUrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758319AbYCSToj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:44:39 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:35772 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758311AbYCSToi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:44:38 -0400
Date: Wed, 19 Mar 2008 15:44:34 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: header files of questionable value
Message-ID: <alpine.LFD.1.00.0803191542310.20340@localhost.localdomain>
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


  a quick run of one of my scanning scripts shows the following header
files under include/linux that no one appears to be including,
although some of them are being exported to userspace:

  fd1772.h
  if_wanpipe.h
  can/error.h
  mtd/jedec.h
  hdsmart.h
  dvb/version.h   [i think this one's all right]

anyone have any hard opinions on any of the above?

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
