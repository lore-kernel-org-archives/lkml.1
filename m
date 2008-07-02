Return-Path: <linux-kernel-owner+w=401wt.eu-S1756174AbYGBOIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbYGBOIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 10:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbYGBOId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 10:08:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60230 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444AbYGBOId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 10:08:33 -0400
Message-ID: <486B8BDE.5080108@firstfloor.org>
Date: Wed, 02 Jul 2008 16:08:30 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] Fix copy_user on x86
References: <m37icazgt0.fsf@gravicappa.englab.brq.redhat.com>	<alpine.LFD.1.10.0806281108240.4371@hp.linux-foundation.org>	<m3lk0ngdo5.fsf@gravicappa.englab.brq.redhat.com>	<alpine.LFD.1.10.0806300835220.28533@hp.linux-foundation.org> <m3bq1gjsty.fsf_-_@gravicappa.englab.brq.redhat.com>
In-Reply-To: <m3bq1gjsty.fsf_-_@gravicappa.englab.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Haven't read the whole change, sorry. It's fairly large (perhaps split it up?)

But generally signed-off-by should be at the end of the description, not the end
of the patch.

> 
> Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
> 


-Andi
