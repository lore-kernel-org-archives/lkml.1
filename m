Return-Path: <linux-kernel-owner+w=401wt.eu-S1761805AbZDQQPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761805AbZDQQPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761773AbZDQQOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:14:54 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:41550 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761797AbZDQQOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:14:53 -0400
X-Greylist: delayed 3083 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Apr 2009 12:14:52 EDT
Date: Fri, 17 Apr 2009 11:22:38 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: include/linux/compiler-gcc[34].h no longer referenced?
Message-ID: <alpine.LFD.2.00.0904171120490.16701@localhost.localdomain>
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


  from my latest cleanup script run on the current source, it would
appear that neither of those two header files are being included
anymore.  remove?

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
