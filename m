Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbXKUUL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbXKUUL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 15:11:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbXKUULr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 15:11:47 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:55096
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752893AbXKUULr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 15:11:47 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 0/4] more RT balancing enhancements v6a
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>
Date: Wed, 21 Nov 2007 14:51:56 -0500
Message-ID: <20071121194804.8226.1522.stgit@novell1.haskins.net>
In-Reply-To: <20071121043648.6315.29246.stgit@novell1.haskins.net>
References: <20071121043648.6315.29246.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These patches apply to the end of the rt-balance-patches v6 annouced here:

http://lkml.org/lkml/2007/11/20/613

Changes since v1:

*) Rebased from v4 to v6
*) original patch #1 was folded into v6
*) added support for caching online cpus within the root-domain

Comments welcome!

Regards,
-Greg 
