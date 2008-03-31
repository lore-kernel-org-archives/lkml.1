Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbYCaWF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbYCaWF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 18:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbYCaWFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 18:05:49 -0400
Received: from smtp02.mtu.ru ([62.5.255.49]:54966 "EHLO smtp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbYCaWFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 18:05:48 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] [MIPS] make some functions and variables static
Date: Tue,  1 Apr 2008 02:03:19 +0400
Message-Id: <1207001005-2633-1-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
X-DCC-STREAM-Metrics: smtp02.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ralf,

I noticed that a few functions and variables in the MIPS-specific
code can become static, and this series of patches cleans up the
kernel global name space a little bit.

Please consider.

Thanks,
Dmitri Vorobiev
