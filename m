Return-Path: <linux-kernel-owner+w=401wt.eu-S1762263AbYDOH3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762263AbYDOH3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 03:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759425AbYDOH26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 03:28:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49809 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759564AbYDOH25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 03:28:57 -0400
Message-ID: <48045829.1090609@cn.fujitsu.com>
Date: Tue, 15 Apr 2008 15:24:25 +0800
From: Shen Feng <shen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: why 2 Kernel command line and module option parsers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Now we get two Kernel command line and module option parsers, i.e.
lib/cmdline.c
lib/parser.c

I think we'd better merge them into one and make a kernel option standard since
the kernel options become more and more.

                        Shen Feng

