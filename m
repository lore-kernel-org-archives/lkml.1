Return-Path: <linux-kernel-owner+w=401wt.eu-S1763292AbYBLTUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763292AbYBLTUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 14:20:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756984AbYBLTUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 14:20:10 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:36106
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755741AbYBLTUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 14:20:08 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 0/2] migration disabled critical sections
To: rostedt@goodmis.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       ghaskins@novell.com
Date: Tue, 12 Feb 2008 13:29:55 -0500
Message-ID: <20080212182512.10902.66459.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Steven,

I had been working on some ideas related to saving context switches in the
bottom-half mechanisms on -rt.  So far, the ideas have been a flop, but a few
peripheral technologies did come out of it.  This series is one such
idea that I thought might have some merit on its own.  The header-comments
describe it in detail, so I wont bother replicating that here.

This series applies to 24-rt1.  Any comments/feedback welcome.

-Greg


