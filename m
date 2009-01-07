Return-Path: <linux-kernel-owner+w=401wt.eu-S1758248AbZAGQlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248AbZAGQlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 11:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbZAGQlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 11:41:13 -0500
Received: from an-out-0708.google.com ([209.85.132.251]:24907 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbZAGQlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 11:41:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:x-mailer;
        b=tkFReX6cSFpyJqg27nSqaaq1QotyTSO1XKZMdIM1CZsETGjmAM33+vjPq48nSyVn/7
         F5ov48nV6LZm/bMQsQeXSR27Cj52W78E1mG3GcT8f7tcxlwdFfIswfa+GrQBxJW4521H
         pG/UF8ObBU8aUEB8mpHugo2j1CtwSN2tnZOzc=
From: Bryan Wu <cooloney@kernel.org>
To: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Blackfin NFC Driver updates
Date: Thu,  8 Jan 2009 00:41:56 +0800
Message-Id: <1231346519-28603-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi folks,

Here are 3 bug fixing patches for Blackfin NFC driver.

Thanks
-Bryan
