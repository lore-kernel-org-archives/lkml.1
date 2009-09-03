Return-Path: <linux-kernel-owner+w=401wt.eu-S1753707AbZICIaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbZICIaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 04:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbZICIaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 04:30:23 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:37878 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752294AbZICIaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 04:30:23 -0400
Subject: Re: [PATCH v2 0/5] kmemleak: few small cleanups and clear command
	support
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, mcgrof@gmail.com
In-Reply-To: <1251956140-5499-1-git-send-email-lrodriguez@atheros.com>
References: <1251956140-5499-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 03 Sep 2009 09:30:13 +0100
Message-Id: <1251966613.22485.7.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Sep 2009 08:30:14.0791 (UTC) FILETIME=[C2B26170:01CA2C70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-03 at 01:35 -0400, Luis R. Rodriguez wrote:
> Still not sure who this goes through so sending this to Linus.

As Pekka said, in some parts of the world the working day just started.
BTW, as I'm the kmemleak maintainer, the patches should probably go
through me (or at least get an ack), especially since I have other
kmemleak patches to push (the kmemleak branch on
git://linux-arm.org/linux-2.6.git).

Thanks. I'll have a look at the patches today.

-- 
Catalin

