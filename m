Return-Path: <linux-kernel-owner+w=401wt.eu-S1755878AbYJOVEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbYJOVEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 17:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754324AbYJOVDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 17:03:01 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:4523 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbYJOVC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 17:02:57 -0400
X-BigFish: VPS-4(zz4015Mzzzzz32i61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K8ST48-01-4G6-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: [PATCH 0/8] OProfile cleanup patches for v2.6.28
Date: Wed, 15 Oct 2008 22:09:02 +0200
Message-ID: <1224101350-12877-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <20081015110444.GA28703@elte.hu>
References: <20081015110444.GA28703@elte.hu>
X-OriginalArrivalTime: 15 Oct 2008 21:02:38.0753 (UTC) FILETIME=[5B2B1110:01C92F09]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

I have added these cleanup patches to oprofile-for-tip on
git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git.

Please pull from there.

In oprofile-for-tip are also patches merged in from
x86-oprofile-for-tip. These patches are also for v2.6.28:

Andi Kleen (4):
      oprofile: drop const in num counters field
      oprofile: Don't report Nehalem as core_2
      oprofile: Implement Intel architectural perfmon support
      oprofile: discover counters for op ppro too

Thanks,

-Robert



