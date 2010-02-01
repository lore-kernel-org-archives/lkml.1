Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab0BAQoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 11:44:21 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:57399 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909Ab0BAQoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 11:44:19 -0500
From: Darren Hart <dvhltc@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org
Subject: [PATCH 0/3] trace-cmd: compile warning fixes
Date: Mon,  1 Feb 2010 08:44:03 -0800
Message-Id: <1265042646-24573-1-git-send-email-dvhltc@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series fixes a few minor compiler warnings. These are
mostly printf format type issues. Also includes an uninitialized
variable fix.

--
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team

