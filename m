Return-Path: <linux-kernel-owner+w=401wt.eu-S1758311AbZD2PsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311AbZD2PsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 11:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757344AbZD2PsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 11:48:03 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:46654 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbZD2PsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 11:48:01 -0400
Date: Wed, 29 Apr 2009 11:46:59 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: "(unsigned long)__builtin_return_address(0)", _RET_IP_,
 CALLER_ADDR0?
Message-ID: <alpine.LFD.2.00.0904291137300.9262@localhost.localdomain>
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


  as another possibility for standardizing code, is there a standard
for the simplification mentioned in the subject and documented here:

http://www.crashcourse.ca/wiki/index.php/The_style_script#Testing_for_.22.28unsigned_long.29__builtin_return_address.280.29.22_simplification

it's a bit confusing that, even within the kernel/ directory, all
three constructs are used, even sometimes being mixed in the same
source file, which is really more confusing than it has to be.

  is there a standard?

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
