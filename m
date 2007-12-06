Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbXLFPuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbXLFPuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 10:50:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbXLFPt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 10:49:57 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:38882
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751392AbXLFPt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 10:49:56 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 0/2] sched: misc. fix and cleanup for sched-devel
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org, ghaskins@novell.com
Date: Thu, 06 Dec 2007 10:27:51 -0500
Message-ID: <20071206152536.7031.16101.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,
   Here are a few more small patches for consideration in sched-devel.

The second patch should be Ack'd by Steven before accepting to make sure I
didn't misunderstand here...but I believe that logic is now defunct since he
moved away from the overlapped cpuset work some time ago.

Regards,
-Greg
