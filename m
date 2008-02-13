Return-Path: <linux-kernel-owner+w=401wt.eu-S1762898AbYBMKy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762898AbYBMKy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 05:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbYBMKyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 05:54:19 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:38446 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbYBMKyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 05:54:17 -0500
Date: Wed, 13 Feb 2008 05:54:12 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Tests of undefined CONFIG variables.
Message-ID: <alpine.LFD.1.00.0802130552370.19968@localhost.localdomain>
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


  i've also updated the list of what i call "badref" CONFIG variables
-- that is, tests of CONFIG_ variables that appear to be undefined
anywhere in a Kconfig file (which typically represents a meaningless
test, naturally).

http://www.crashcourse.ca/wiki/index.php/Badref_CONFIG_variables

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
