Return-Path: <linux-kernel-owner+w=401wt.eu-S1762679AbYDTCys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762679AbYDTCys (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 22:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbYDTCyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 22:54:38 -0400
Received: from smtp01.mtu.ru ([62.5.255.48]:51485 "EHLO smtp01.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbYDTCyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 22:54:37 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] x86: random clean-ups
Date: Sun, 20 Apr 2008 06:54:30 +0400
Message-Id: <1208660074-7324-1-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
X-DCC-STREAM-Metrics: smtp01.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Peter, Thomas,

The following patches contain a few clean-ups, mostly
stemming from analyzis of sparse messages.

The patches are against current x86.git.

Please consider.

Thanks,
Dmitri Vorobiev
