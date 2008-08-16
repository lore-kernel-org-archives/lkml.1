Return-Path: <linux-kernel-owner+w=401wt.eu-S1753769AbYHPTWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbYHPTWc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 15:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbYHPTVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 15:21:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:15952 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbYHPTVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 15:21:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=WlhOTRwJAaMOW+ehgUl3G997bPlrnT34m3OjmABDdsVwE4b8NYt4AWFcbn9853kCuu
         7vwBBjikxLnnMUS7xC/so07hvX2eTVlhZJZhJkaKHoozgxow32E4nAphkViDp0PWjSRc
         /DnhUnzlzb7luDl6REDi7J7g5N1venJme6X6o=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, macro@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: one more apic merging preliminary series
Date: Sat, 16 Aug 2008 23:21:49 +0400
Message-Id: <1218914515-26377-1-git-send-email-gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.rc1.34.g0fe8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please review - any comments are welcome!

For now it's like code bloating - but it's just preliminary
series to make apic_*.c code more or less similar.
And it's still a bit far from being ready to be merged down.

		- Cyrill -
