Return-Path: <linux-kernel-owner+w=401wt.eu-S1751827AbZL2M1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbZL2M1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 07:27:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbZL2M1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 07:27:09 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:45950 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbZL2M1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 07:27:08 -0500
Date: Tue, 29 Dec 2009 07:26:28 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: any objection to a wide-sweeping "unifdef-y" -> "header-y" change?
Message-ID: <alpine.LFD.2.00.0912290724360.16947@localhost>
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


  given that the Kbuild "unifdef-y" directive was tagged as obsolete
in favour of "header-y" well over a year ago, any objection to just
standardizing everything on header-y and removing all support
for unifdef-y?

  is there any compelling reason to *not* do that?

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
