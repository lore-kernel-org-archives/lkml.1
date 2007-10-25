Return-Path: <linux-kernel-owner+w=401wt.eu-S1761497AbXJYPBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761497AbXJYPBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 11:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757991AbXJYPBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 11:01:09 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:45103
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754662AbXJYPBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 11:01:08 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 0/3] RT: balance rt tasks enhancements v6
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
Date: Thu, 25 Oct 2007 10:46:18 -0400
Message-ID: <20071025144456.19876.94333.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a mini-release of my series, rebased on -rt2.  I have more changes
downstream which are not quite ready for primetime, but I need to work on some
other unrelated issues right now and I wanted to get what works out there. 

Changes since v5

*) Rebased to rt2 - Many of the functions of the original series are now
 included in base -rt so they are dropped out

