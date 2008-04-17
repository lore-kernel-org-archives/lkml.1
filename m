Return-Path: <linux-kernel-owner+w=401wt.eu-S933697AbYDQBeD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933697AbYDQBeD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:34:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932530AbYDQBQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:16:25 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:49677 "EHLO
	QMTA03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760342AbYDQBQY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:16:24 -0400
X-Authority-Analysis: v=1.0 c=1 a=81MVaMzL4IIA:10 a=MC0mamqS7d4A:10
 a=3JgGrMvpAysF6h7O_gQA:9 a=QU4gCfpQ2EuUItA3O3jHGwHSl1QA:4 a=50e4U0PicR4A:10
From: Dmitry Torokhov <dtor@insightbb.com>
To: Marcus Furlong <furlongm@hotmail.com>
Subject: Re: [BUG] 2.6.25-rc9 Oops (keyboard/mouse related)
Date: Wed, 16 Apr 2008 21:16:14 -0400
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <fu66a8$flv$1@ger.gmane.org>
In-Reply-To: <fu66a8$flv$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804162116.14712.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcus,

On Wednesday 16 April 2008, Marcus Furlong wrote:
> Hi,
> 
> I got the following oops on 2.6.25-rc9. The mouse/keyboard are
> consistently "jerky" and unresponsive, and between 1 and 15 minutes after
> booting the machine hangs.
> 
> Possibly the same on 2.6.24.*, I only tried it once and it hung and I had no
> more time for testing until now. No problem on 2.6.23.17.
> 
> [  854.789883] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [  854.792850] Modules linked in: i915 drm iwl3945 mac80211 cfg80211
> intel_agp agpgart scsi_wait_scan
> [  854.792850]

Hmm, it looks like the very first line or two are missing... Could I
get the whole dmesg (so I can see exactly what kind of ALPS touchpad
you have) please?

Thanks!

-- 
Dmitry
