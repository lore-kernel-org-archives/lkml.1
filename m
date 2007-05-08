Return-Path: <linux-kernel-owner+w=401wt.eu-S934886AbXEHJvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934886AbXEHJvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 05:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934877AbXEHJvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 05:51:16 -0400
Received: from dialup.esmr.ru ([85.94.3.83]:34817 "EHLO localhost.localdomain"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S934868AbXEHJvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 05:51:12 -0400
From: Vitaly Bordug <vitb@kernel.crashing.org>
To: linux-pcmcia@lists.infradead.org
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] 8xx PCMCIA stuff && cleanup: take 3
Date: Tue, 08 May 2007 13:50:32 +0400
Message-ID: <20070508095001.20018.85403.stgit@localhost.localdomain>
User-Agent: StGIT/0.11
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for such amount of noise, have to resubmit to catch up
with Olof's notes, and to kill empty ranges property in dts since
it is not appropriate before driver could handle it.

Thanks all for attention.
-- 
Sincerely, Vitaly
