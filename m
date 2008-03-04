Return-Path: <linux-kernel-owner+w=401wt.eu-S1761367AbYCDHKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761367AbYCDHKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 02:10:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521AbYCDHJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 02:09:55 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:44114 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725AbYCDHJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 02:09:54 -0500
Date: Tue, 4 Mar 2008 09:08:15 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: torvalds@linux-foundation.org, gerg@uclinux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [M68KNOMMU]: update defconfig
Message-ID: <20080304070815.GO26072@cs181133002.pp.htv.fi>
References: <200803040544.m245iNo6017912@goober>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200803040544.m245iNo6017912@goober>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

a related wish:

Could you add more defconfigs (all in arch/m68knommu/configs/) so that 
building all defconfig will give a compile coverage of all platforms?

This way it would be easier to find compile breakages early.

TIA
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

