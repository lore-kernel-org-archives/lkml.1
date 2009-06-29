Return-Path: <linux-kernel-owner+w=401wt.eu-S1758601AbZF2NPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601AbZF2NPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 09:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbZF2NPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 09:15:04 -0400
Received: from sg2ehsobe005.messaging.microsoft.com ([207.46.51.79]:52194 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754171AbZF2NPD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 09:15:03 -0400
X-SpamScore: -22
X-BigFish: VPS-22(z21eWz98dRzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KM04SF-03-FZA-01
Date: Mon, 29 Jun 2009 15:14:40 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.30-rc1] lockdep false positive in DMA debug API...
Message-ID: <20090629131440.GN5139@amd.com>
References: <6278d2220906280405y731f7f2l65472ec5f62dbc83@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <6278d2220906280405y731f7f2l65472ec5f62dbc83@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 29 Jun 2009 13:14:40.0922 (UTC) FILETIME=[8FA3CFA0:01C9F8BB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 28, 2009 at 12:05:17PM +0100, Daniel J Blueman wrote:
> With 2.6.30-rc1, I'm seeing the lockdep validator spinning it's wheels
> [1] (also already seen [2]) on the DMA debug interface, with the
> hashed locks.

If you don't actually mean 2.6.3_1_-rc1 this is a known bug which was
fixed for 2.6.30-final.

	Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

