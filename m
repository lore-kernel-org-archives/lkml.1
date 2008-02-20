Return-Path: <linux-kernel-owner+w=401wt.eu-S1762073AbYBTF6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762073AbYBTF6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 00:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbYBTF6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 00:58:23 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:52646 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875AbYBTF6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 00:58:22 -0500
Date: Wed, 20 Feb 2008 07:57:44 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: flatif@neteffect.com, gstreiff@neteffect.com, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] [2.6 patch] infiniband/hw/nes/nes_verbs.c: fix
	off-by-one
Message-ID: <20080220055744.GC31955@cs181133002.pp.htv.fi>
References: <20080219225900.GR31955@cs181133002.pp.htv.fi> <adahcg4fe88.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <adahcg4fe88.fsf@cisco.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 08:23:19PM -0800, Roland Dreier wrote:
> Thanks, this is already upstream as 51af33e8

No, 51af33e8 was for a similar same bug 400 lines below this bug...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

