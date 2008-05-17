Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964AbYEQLBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbYEQLBb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 07:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbYEQLBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 07:01:21 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:52978 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbYEQLBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 07:01:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:sender;
        b=QJjqQy+8xz7Pvza7/ptbStqw7VeRPORD32mrZa02vZTVTDIm6qRs6/qPLMgkmXkqtNWKfxOKVoBVopOECwqXD/lwg7vZm2kOpLM7QC+VVlV54hBzZ09R4rI/m6I4KbVK3Ulh9oEaBXnEuOZmGUz9piStmiDNHBBFrWUTU+3CAyU=
From: Bryan Wu <cooloney@kernel.org>
To: me@felipebalbi.com, david-b@pacbell.net, tony@atomide.com
Cc: linux-omap@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] MUSB: 2 patches to fix some bug found on Blackfin
Date: Sat, 17 May 2008 19:01:19 +0800
Message-Id: <1211022081-27298-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi folks,

We discussed these 4 bugs before. Now we fixed them.
Please review following 2 patches.

Thanks
-Bryan
