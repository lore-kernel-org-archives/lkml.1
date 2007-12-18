Return-Path: <linux-kernel-owner+w=401wt.eu-S1761364AbXLRSU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761364AbXLRSU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 13:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbXLRSUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 13:20:15 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58931 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbXLRSUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 13:20:14 -0500
Message-Id: <20071218174120.711901000@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 18 Dec 2007 18:41:20 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH 0/3] various scheduler patches
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch fixes a serious bug in RT task accounting and should go in .24

The latter two add a RT watchdog rlimit that ensures RT tasks don't
unintentionally hog the cpu.

--

