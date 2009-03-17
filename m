Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbZCQWG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbZCQWG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 18:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754430AbZCQWGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 18:06:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50345 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbZCQWGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 18:06:13 -0400
Message-Id: <20090317215606.037073805@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 17 Mar 2009 22:56:06 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, paulus@samba.org, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 00/11] tracepoint perf counter events and other stuff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RFC because the patch stack seems to not quite work as expected, will
poke at it more in the morning, but thought I should post it so that
other folks can see what's happening.

-- 

