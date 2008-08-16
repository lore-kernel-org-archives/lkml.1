Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbYHPKIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbYHPKIe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 06:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbYHPKIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 06:08:20 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:46012 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632AbYHPKIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 06:08:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=sfyzp3PlfYwrqoTQsux2Lr0JdHfRyITg+GLnwgFftybbj78MDXyzUEOCk0/3v2Lsun
         xIV00OBHW/83WgPyeoRDoK+RLOvCwgAE0wYZ4luFH/2vt1bd2kJKreWM+AIGY+IS1jPG
         rSLyDcfz8OVTeSsSRl9qlVIJnIZHGNsubgatM=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 0/5] merge io_apic_xx.c -- fix
Date: Sat, 16 Aug 2008 03:07:24 -0700
Message-Id: <1218881249-3028-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    merge io_apic_xx.c

Thanks

Yinghai Lu

