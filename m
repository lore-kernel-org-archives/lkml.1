Return-Path: <linux-kernel-owner+w=401wt.eu-S1760252AbZDLKr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760252AbZDLKr7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 06:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759609AbZDLKrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 06:47:35 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:49838 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759253AbZDLKre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 06:47:34 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] balance parentheses and braces
Date: Sun, 12 Apr 2009 12:47:27 +0200
Message-Id: <1239533251-31276-1-git-send-email-m.kozlowski@tuxland.pl>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using rather dumb script I found some unbalanced parentheses and braces
here and there. These patches are trivial and attepmt to fix them.


