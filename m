Return-Path: <linux-kernel-owner+w=401wt.eu-S1758238AbYEKUDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238AbYEKUDd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 16:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756440AbYEKUDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 16:03:07 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:44595 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143AbYEKUDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 16:03:05 -0400
Date: Sun, 11 May 2008 16:02:59 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: is __setup_null_param() officially obsolete?
Message-ID: <alpine.LFD.1.10.0805111600460.20870@localhost.localdomain>
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


  following up on a thread from some time back, is there any further
use to the __setup_null_param() macro in <linux/init.h>?  certainly,
nothing in the kernel tree uses it these days, and removing it would
simplify the definition of both __setup() and __setup_param().

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
