Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbZLMWtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbZLMWtK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 17:49:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569AbZLMWtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 17:49:08 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:39372 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbZLMWtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 17:49:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=c7WQSVAr5670DiHNnMEKjI6o0DZ2rokzFgdAMInDXx8Nm7vsC5OPM/l1zOpCgncRSN
         ZBJUtwN/aA6scG2CPdMp9cxpSzMD+gU5cTfrkDFFxUo+dqcVSYOL1t4G/Ma46T02lwzU
         3sXTim1wQPW6dDsgcyD/UnU/YVLTPgH3xDRMk=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Fix-a-typo-in-battery.c
Date: Sun, 13 Dec 2009 14:48:55 -0800
Message-Id: <1260744536-20762-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Fix a typo in a comment in
 drivers/acpi/battery.c

 drivers/acpi/battery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


