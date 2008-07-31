Return-Path: <linux-kernel-owner+w=401wt.eu-S1759185AbYGaA4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759185AbYGaA4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbYGaA4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:56:46 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:34989 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbYGaA4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:56:46 -0400
Date: Wed, 30 Jul 2008 20:55:11 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: updated list of "badref" CONFIG variables
Message-ID: <alpine.LFD.1.10.0807302052450.13693@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
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


  since the merge window seems to be winding down, i've posted the
latest scan for "badref" CONFIG variables here:

http://www.crashcourse.ca/wiki/index.php/Badref_CONFIG_variables

  unlike simple *unused* CONFIG variables, these are variables that
*are* actually being referenced and tested in the tree somewhere, but
are not defined anywhere in a Kconfig file.  it's all broken down by
directory and subdirectory.  enjoy.

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
