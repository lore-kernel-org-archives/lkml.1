Return-Path: <linux-kernel-owner+w=401wt.eu-S1753095AbYJ0SaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbYJ0SaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 14:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYJ0SaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 14:30:07 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:30001 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbYJ0SaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 14:30:05 -0400
X-BigFish: VPS-40(z34a4jz62a3L1432R98dR936eQ1805M936fOzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K9EU1J-01-M6A-01
Date: Mon, 27 Oct 2008 19:29:27 +0100
From: Robert Richter <robert.richter@amd.com>
To: Jesper Dangaard Brouer <jdb@comx.dk>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH trivial fix] Change UTF8 chars in Kconfig help text
	about Oprofile AMD barcelona
Message-ID: <20081027182927.GG9785@erda.amd.com>
References: <1224853512.2019.129.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1224853512.2019.129.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 27 Oct 2008 18:29:47.0851 (UTC) FILETIME=[FDD779B0:01C93861]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.10.08 15:05:12, Jesper Dangaard Brouer wrote:
> 
> Fixes screwing up text output when doing a make oldconfig and viewing
> help text of "OProfile AMD IBS support".  When the terminal is
> not using an UTF8 locale / LANG.  "make config" breaks terminal output
> and its not possible to continue.
> 
> (Change added by changeset 852402cc Tue Jul 22 21:09:06 2008)
> 
> Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>

I applied your patch to oprofile/oprofile-for-tip. Thanks Jesper.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

