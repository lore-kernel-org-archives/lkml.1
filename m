Return-Path: <linux-kernel-owner+w=401wt.eu-S1761752AbXGaNZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761752AbXGaNZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760750AbXGaNYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:24:30 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:49909
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760465AbXGaNY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:24:29 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 0/2][RFC] VFCIPI v3
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ghaskins@novell.com
Date: Tue, 31 Jul 2007 09:24:11 -0400
Message-ID: <20070731132153.4790.37217.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog from v2:

1) Converted "smp_call_funtion[_single]__nodelay" to
   "raw_smp_call_function[_single]" to match existing nomenclature in the -rt
   series.

2) Removed all PI related code from Patch #1 and moved it to #2 where it
   belonged.

Signed-off-by: Gregory Haskins <ghaskins@novell.com> 
