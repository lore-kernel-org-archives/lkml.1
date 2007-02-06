Return-Path: <linux-kernel-owner+w=401wt.eu-S1752640AbXBFDw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbXBFDw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 22:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbXBFDw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 22:52:29 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:49450 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752640AbXBFDw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 22:52:28 -0500
Date: Mon, 5 Feb 2007 19:52:08 -0800
Message-Id: <200702060352.l163q87K000713@zach-dev.vmware.com>
Subject: [PATCH 0/11] VMI / Paravirt bugfixes for 2.6.21
From: Zachary Amsden <zach@vmware.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>
X-OriginalArrivalTime: 06 Feb 2007 03:52:26.0600 (UTC) FILETIME=[37614680:01C749A2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A bunch of VMI and paravirt-ops bugfixes for upstream.  Also, fix the
timer code to work for 2.6.21, which had a number of changes.

These should mostly be non-controversial and beneficial to all the
paravirt-ops work.

Zach <zach@vmware.com>
