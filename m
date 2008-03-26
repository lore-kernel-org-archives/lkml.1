Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbYCZIip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbYCZIip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 04:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbYCZIif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 04:38:35 -0400
Received: from mail.netone.net.tr ([193.192.98.182]:16357 "EHLO
	mail.netone.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbYCZIie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 04:38:34 -0400
Message-ID: <47EA0B88.40009@netone.net.tr>
Date: Wed, 26 Mar 2008 10:38:32 +0200
From: Tarkan Erimer <tarkan@netone.net.tr>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [BUG] Linux 2.6.24.x and 2.6.25-rc1-6 boot freeze
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Mar 2008 08:36:39.0670 (UTC) FILETIME=[82D1C160:01C88F1C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tried to boot 2.6.24.x and 2.6.25-rc1-6 on my machine (Pentium D 2.8 
GHZ CPU/1 GB RAM)
and when it began to boot; at the 1st second, it freezes completely. 
There is nothing at the logs and SysRq does not effect. On the same 
machine < 2.6.24.x kernels work fine. Anyway to diagnose this problem 
more deeply ?

Tarkan
