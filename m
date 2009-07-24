Return-Path: <linux-kernel-owner+w=401wt.eu-S1752969AbZGXPU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbZGXPU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 11:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752452AbZGXPUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 11:20:25 -0400
Received: from mail09.linbit.com ([212.69.161.110]:45200 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbZGXPUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 11:20:24 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [Drbd-dev] [PATCH 00/16] drbd: a block device for HA clusters
Date: Fri, 24 Jul 2009 17:20:21 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>,
       Andrew Morton <akpm@linux-foundation.org>, drbd-dev@lists.linbit.com,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
References: <1246894775-10855-1-git-send-email-philipp.reisner@linbit.com> <20090721185156.GA10126@johann> <20090722145917.055eddc1.sfr@canb.auug.org.au>
In-Reply-To: <20090722145917.055eddc1.sfr@canb.auug.org.au>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907241720.22771.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 July 2009 06:59:17 Stephen Rothwell wrote:
> Hi Lars,
>
> On Tue, 21 Jul 2009 20:51:56 +0200 Lars Ellenberg 
<lars.ellenberg@linbit.com> wrote:
> > Stephen: expect an explicit linux-next merge request
> > within the next few days.
>
> OK, just to be clear your tree should be based on Linus' tree (or some
> other *stable*, non rebasing, tree - *not* linux-next).
>

Hi Stephen,

Please add git://git.drbd.org/linux-2.6-drbd.git to linux-next.

The tree was initially based on v2.6.30-rc1. Later 2.6.31-rc1 was
merged in. 
I verified that it still merges with 2.6.31-rc4 without conflicts.

Thanks!

-Philipp
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.

