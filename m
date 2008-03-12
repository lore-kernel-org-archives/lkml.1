Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbYCLUfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbYCLUfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 16:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbYCLUed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 16:34:33 -0400
Received: from zaphod.rfc1149.net ([88.191.14.223]:43263 "EHLO
	mail.rfc1149.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbYCLUeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 16:34:31 -0400
From: Samuel Tardieu <sam@rfc1149.net>
To: linux-kernel@vger.kernel.org, wim@iguana.be
Cc: P@draigBrady.com
Subject: w83697hf_wdt.c cleanup and new option
Date: Wed, 12 Mar 2008 14:28:00 +0100
Message-Id: <1205328483-3814-1-git-send-email-sam@rfc1149.net>
X-Mailer: git-send-email 1.5.4.3.611.g29c00.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The first two patches in the series do some cleanup, while the third one
adds an early_disable option (on by default) as requested by Pádraig
Brady.
