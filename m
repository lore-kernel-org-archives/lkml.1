Return-Path: <linux-kernel-owner+w=401wt.eu-S1757795AbYHBPvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795AbYHBPvB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 11:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbYHBPum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 11:50:42 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:59994 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbYHBPul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 11:50:41 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [PATCH 0/1] delta patch to arch/x86/kernel/traps_64.c
Date: Sat,  2 Aug 2008 12:50:36 -0300
Message-Id: <1217692237-17603-1-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <gustavo@las.ic.unicamp.br>
References: <gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

This patch fixes coding style to previous patch to traps_64.c
(4df9e510a9fda29aca71d8acac853b98aa6884d1 on tip/x86/cleanups).



