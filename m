Return-Path: <linux-kernel-owner+w=401wt.eu-S1762889AbZDHLW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762889AbZDHLW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758746AbZDHLWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:22:35 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:40096 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755261AbZDHLWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:22:34 -0400
X-Sasl-enc: PcN3XDkq5m9IZ9fP7Yl8PeT6BIih7BQC1+mpH8DEHqAG 1239189752
From: Jack Stone <jwjstone@fastmail.fm>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 0/56] Remove void casts
Date: Wed,  8 Apr 2009 12:21:32 +0100
Message-Id: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series removes void pointer casts from the kernel.

These casts are not needed in C.

These patches are against Linus' tree
