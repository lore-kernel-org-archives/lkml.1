Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbYGVO0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbYGVO0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 10:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbYGVO0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 10:26:08 -0400
Received: from viefep32-int.chello.at ([62.179.121.50]:36430 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbYGVO0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 10:26:07 -0400
Subject: Re: [PATCH]
	cpu	hotplug,	sched:Introduce	cpu_active_map	and	redoscheddomainmanagment
	(take	2)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>, mingo@elte.hu,
       dmitry.adamushko@gmail.com, torvalds@linux-foundation.org, pj@sgi.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <4885EC11.2050906@novell.com>
References: <1216122229-4865-1-git-send-email-maxk@qualcomm.com>
	 <487DAD86.BA47.005A.0@novell.com> <487E6BD7.3020006@qualcomm.com>
	 <487E7B6C.BA47.005A.0@novell.com> <487EF1E9.2040101@qualcomm.com>
	 <487EFB71.BA47.005A.0@novell.com> <487F9509.9050802@qualcomm.com>
	 <487F6972.BA47.005A.0@novell.com> <1216382024.28405.26.camel@twins>
	 <488052D5.BA47.005A.0@novell.com> <48856BA9.6050609@qualcomm.com>
	 <4885E952.8020708@novell.com> <1216736160.7257.97.camel@twins>
	 <4885EC11.2050906@novell.com>
Content-Type: text/plain
Date: Tue, 22 Jul 2008 16:26:04 +0200
Message-Id: <1216736764.7257.99.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-22 at 10:17 -0400, Gregory Haskins wrote:

> Thanks Peter.
> 
> BTW: I should mention that this was just an RFC.  I haven't even build 
> tested it yet.  I will do this now.

Heh, might make sense to ensure it indeed builds before stuffing it into
-tip ;-)

