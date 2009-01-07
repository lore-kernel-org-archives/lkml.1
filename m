Return-Path: <linux-kernel-owner+w=401wt.eu-S1762537AbZAGWYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762537AbZAGWYK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:24:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762142AbZAGWXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:23:15 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:59504 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761917AbZAGWXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:23:12 -0500
X-BigFish: VPS3(zzzzzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KD4GU3-02-XT5-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: [0/18] oprofile: fixes and cleanup patches
Date: Wed, 7 Jan 2009 23:17:17 +0100
Message-ID: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
X-OriginalArrivalTime: 07 Jan 2009 22:22:59.0241 (UTC) FILETIME=[7F1A2990:01C97116]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains some fixes and cleanups, mostly
trivial. The patches are in preparation of the implementation of
support for variable data size samples.



