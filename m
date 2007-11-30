Return-Path: <linux-kernel-owner+w=401wt.eu-S935484AbXK3RI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935484AbXK3RI2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 12:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935431AbXK3RIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 12:08:10 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:43061
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935406AbXK3RII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 12:08:08 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 0/4] more RT balancing enhancements v6b
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML 
	<"linux-kernel@vger.kernel.org>, linux-rt-users"@vger.kernel.org>,
       mingo@elte.hu
Date: Fri, 30 Nov 2007 11:46:44 -0500
Message-ID: <20071130163638.30588.47845.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These patches apply to the end of the rt-balance-patches v6 annouced here:

http://lkml.org/lkml/2007/11/20/613

These replace the v6a patches annouced here:

http://lkml.org/lkml/2007/11/21/226

Changes since v6a:

*) made features tunable via config options
*) fixed a bug related to setting a CPU to INVALID
*) vec->mask weight optimization
*) minor tweaks and improvements

Comments welcome!

Regards,
-Greg 
-- 
Signature
