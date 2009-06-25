Return-Path: <linux-kernel-owner+w=401wt.eu-S1757904AbZFYLJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904AbZFYLJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 07:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbZFYLJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 07:09:23 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:51198 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758112AbZFYLJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 07:09:22 -0400
Date: Thu, 25 Jun 2009 07:07:23 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: first pass of kernel cleanup script for -rc1
Message-ID: <alpine.LFD.2.00.0906250704060.12615@localhost>
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


  now that -rc1 is out, i've started to run my cleanup scripts again.
for now, the only page that's been updated is this one:

  http://www.crashcourse.ca/wiki/index.php/Unused_CONFIG_variables

which documents CONFIG variables that are defined in some Kconfig file
but are apparently unused anywhere in the tree.  (some false positives
remain, but it's still fairly informative.)

  the good news:  the output is shrinking from release to release.
the bad news:  some of those variables have been there a *long* time.

  in any event, enjoy.  more cleanup updates will be done today.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
