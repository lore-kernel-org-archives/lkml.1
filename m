Return-Path: <linux-kernel-owner+w=401wt.eu-S1763970AbYCDLpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763970AbYCDLpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 06:45:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756626AbYCDLpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 06:45:40 -0500
Received: from hosted02.westnet.com.au ([203.10.1.213]:47271 "EHLO
	hosted02.westnet.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756607AbYCDLpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 06:45:39 -0500
Message-ID: <47CD365C.70509@snapgear.com>
Date: Tue, 04 Mar 2008 21:45:32 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: torvalds@linux-foundation.org, gerg@uclinux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [M68KNOMMU]: update defconfig
References: <200803040544.m245iNo6017912@goober> <20080304070815.GO26072@cs181133002.pp.htv.fi>
In-Reply-To: <20080304070815.GO26072@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Branch: TNG-Outgoing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Adrian,

Adrian Bunk wrote:
> a related wish:
> 
> Could you add more defconfigs (all in arch/m68knommu/configs/) so that 
> building all defconfig will give a compile coverage of all platforms?

Oh yes, I can add more.
I'll prepare a bunch of them for post 2.6.25 inclusion.


> This way it would be easier to find compile breakages early.

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
SnapGear -- a Secure Computing Company      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
