Return-Path: <linux-kernel-owner+w=401wt.eu-S1763866AbYBMI4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763866AbYBMI4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 03:56:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbYBMI4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 03:56:41 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:36060 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbYBMI4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 03:56:40 -0500
Date: Wed, 13 Feb 2008 03:56:34 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: latest list of unused Kconfig variables
Message-ID: <alpine.LFD.1.00.0802130353530.31183@localhost.localdomain>
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


  now that 2.6.25-rc1 is out, i can start updating the output from my
scanning scripts.  the first updated output is the list of currently
unused Kconfig variables -- variables that are defined in some Kconfig
file somewhere but appear to be entirely unused throughout the source
tree.

  latest output here, sorted by architecture:

http://www.crashcourse.ca/wiki/index.php/Unused_CONFIG_variables

as always, there will probably be some false positives for one reason
or another.

  output from the other scanning scripts will be up in short order.

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
