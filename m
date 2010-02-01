Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab0BAQvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 11:51:04 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:51666 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab0BAQvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 11:51:01 -0500
From: Darren Hart <dvhltc@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org
Subject: [PATCH 0/3 V2] trace-cmd: compiler warning fixes
Date: Mon,  1 Feb 2010 08:50:23 -0800
Message-Id: <1265043026-24987-1-git-send-email-dvhltc@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series fixes a few minor compiler warnings. These are
mostly printf format type issues. Also includes an uninitialized
variable fix.

V2: actually send my patches and not 2 of rostedts...
--
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team

