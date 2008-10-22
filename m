Return-Path: <linux-kernel-owner+w=401wt.eu-S1758740AbYJVTWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740AbYJVTWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757858AbYJVTWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:22:20 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:53664 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756971AbYJVTWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:22:19 -0400
To: "Jesse Brandeburg" <jesse.brandeburg@gmail.com>
cc: linux-kernel@vger.kernel.org, "NetDEV list" <netdev@vger.kernel.org>,
       e1000-devel@lists.sourceforge.net
Subject: Re: e1000e fails after several S3 resumes (2.6.26 Debian, TP T60) 
In-Reply-To: Your message of "Wed, 22 Oct 2008 09:29:21 PDT."
             <4807377b0810220929v5906b42bgf9d63215370e5ab5@mail.gmail.com> (sfid-20081022_141704_643135_AA4BDC9C) 
X-Mailer: MH-E 8.1; nmh 1.2; GNU Emacs 22.2.1
Date: Wed, 22 Oct 2008 15:21:43 -0400
From: Sanjoy Mahajan <sanjoy@MIT.EDU>
Message-Id: <E1KsjH5-0007Mg-0R@approx.mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.  I'll use 'ethregs' and 'ethtool -d eth0' at the next
opportunity, though it might take a few weeks for the problem to recur,

> you'll have to build ethregs which I haven't tried to do on debian,
> but it should be possible.

It needed the 'libpci-dev' package and built smoothly.

> There is also lots of opportunity for BIOS bugs to be effecting things
> so please make sure that you have the latest bios.

It has BIOS 2.20 (79ETE3WW), the latest version when I last upgraded the
BIOS, but I see that 2.23 is available.  I'll upgrade as soon as I
remember how on a Windowless (TM) machine.

-Sanjoy

`Until lions have their historians, tales of the hunt shall always
 glorify the hunters.'  --African Proverb
