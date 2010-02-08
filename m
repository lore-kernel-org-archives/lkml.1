Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab0BHOTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 09:19:22 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:58052 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab0BHOTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 09:19:20 -0500
X-SpamScore: -13
X-BigFish: VPS-13(zz1432R98dNzz1202hzzz32i6bh87h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KXJ12M-01-7B7-02
X-M-MSG: 
Date: Mon, 8 Feb 2010 15:18:22 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Julia Lawall <julia@diku.dk>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/11] arch/x86/kernel: Correct NULL test
Message-ID: <20100208141821.GD16236@amd.com>
References: <Pine.LNX.4.64.1002060942170.8092@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1002060942170.8092@ask.diku.dk>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 08 Feb 2010 14:18:22.0498 (UTC) FILETIME=[92020820:01CAA8C9]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 06, 2010 at 09:42:39AM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> dev was tested just above, so drop the second test.

Applied to amd-iommu/fixes. Thanks Julia.

	Joerg

