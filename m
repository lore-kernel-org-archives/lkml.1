Return-Path: <linux-kernel-owner+w=401wt.eu-S1756325AbYC1CZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325AbYC1CZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 22:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbYC1CYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 22:24:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:55381 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754444AbYC1CYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 22:24:50 -0400
Cc: "Zhang Wei" <wei.zhang@freescale.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org
Message-Id: <9D668111-9774-4D45-944E-3C3C0EE47A09@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Dan Williams <dan.j.williams@intel.com>
In-Reply-To: <e9c3a7c20803271237x1b2c3a2ci6837c5e2d5288c95@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH] fsldma: The MPC8377MDS board device tree node for fsldma driver
Date: Thu, 27 Mar 2008 21:23:54 -0500
References: <1206517356-11209-1-git-send-email-wei.zhang@freescale.com> <1206517356-11209-2-git-send-email-wei.zhang@freescale.com> <e9c3a7c20803271237x1b2c3a2ci6837c5e2d5288c95@mail.gmail.com>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 27, 2008, at 2:37 PM, Dan Williams wrote:
> On Wed, Mar 26, 2008 at 12:42 AM, Zhang Wei  
> <wei.zhang@freescale.com> wrote:
>> The fsldma driver is tested on MPC8377MDS board.
>> The patch adds fsldma driver support into MPC8377MDS device tree.
>>
>> Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
>> ---
>>  arch/powerpc/boot/dts/mpc8377_mds.dts |   27 ++++++++++++++++++++++ 
>> +++++
>>  1 files changed, 27 insertions(+), 0 deletions(-)
>
> I think this patch should probably go through the powerpc tree, or
> -mm.  I'll pick up the ones that touch either drivers/dma or
> crypto/async_tx.

Can you resend and CC me.  I'll pick it up and push through via the  
powerpc tree.

I want to make one update to the driver to support the "proper" names  
we document for compatible properties.

(uugh too many things to do)

- k
