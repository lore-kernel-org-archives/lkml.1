Return-Path: <linux-kernel-owner+w=401wt.eu-S932540AbYBMXmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540AbYBMXmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 18:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757474AbYBMXmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 18:42:14 -0500
Received: from namei.org ([69.55.235.186]:42028 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756443AbYBMXmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 18:42:13 -0500
Date: Thu, 14 Feb 2008 10:41:19 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Paul Moore <paul.moore@hp.com>
cc: Adrian Bunk <bunk@kernel.org>, coreteam@netfilter.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make secmark_tg_destroy() static
In-Reply-To: <200802131634.51116.paul.moore@hp.com>
Message-ID: <Xine.LNX.4.64.0802141040440.3559@us.intercode.com.au>
References: <20080213212940.GH3383@cs181133002.pp.htv.fi>
 <200802131634.51116.paul.moore@hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Paul Moore wrote:

> On Wednesday 13 February 2008 4:29:40 pm Adrian Bunk wrote:
> > This patch makes the needlessly global secmark_tg_destroy() static.
> >
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> Thanks for catching this.
> 
> Acked-by: Paul Moore <paul.moore@hp.com>
> 

Applied -- will push to Linus unless the netfilter folk do it first.


- James
-- 
James Morris
<jmorris@namei.org>
