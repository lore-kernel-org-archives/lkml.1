Return-Path: <linux-kernel-owner+w=401wt.eu-S1752028AbZKPKHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbZKPKHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 05:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbZKPKHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 05:07:21 -0500
Received: from smtp.nokia.com ([192.100.122.230]:54977 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbZKPKHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 05:07:19 -0500
Subject: Re: linux-next: manual merge of the omap_dss2 tree with the omap
 tree
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: Tony Lindgren <tony@atomide.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       ext Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20091116160402.deb0cc82.sfr@canb.auug.org.au>
References: <20091116160402.deb0cc82.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Nov 2009 12:06:41 +0200
Message-ID: <1258366001.2384.25.camel@tubuntu.research.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Nov 2009 10:06:46.0737 (UTC) FILETIME=[8188B410:01CA66A4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-16 at 06:04 +0100, ext Stephen Rothwell wrote:
> Hi Tomi,
> 
> Today's linux-next merge of the omap_dss2 tree got a conflict in
> arch/arm/configs/omap_3430sdp_defconfig between the omap tree and the
> omap_dss2 tree.
> 
> I just used the version from the omap tree as I can't figure out anything
> better, sorry.

Tony, 

These patches in omap tree seem to cause the conflicts. Are they stable,
ie. can I cherry pick them to my for-next tree, and put my patches on
top of them?

b30dcf5f37023d591caee80c233bf33706bc5a21
omap3: 3430sdp: Enable Linux Regulator framework

fc89f86e06c11b8828ce1d6c669f724877546c03
ARM: OMAP3: Fix 3430SDP defconfig

 Tomi


