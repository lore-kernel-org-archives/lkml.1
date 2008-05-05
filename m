Return-Path: <linux-kernel-owner+w=401wt.eu-S1764051AbYEETLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764051AbYEETLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754810AbYEETKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:10:51 -0400
Received: from outbound-mail-22.bluehost.com ([69.89.21.17]:52435 "HELO
	outbound-mail-22.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753257AbYEETKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:10:50 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] make {pciehp,shpchp}_slot_with_bus static
Date: Mon, 5 May 2008 12:10:45 -0700
User-Agent: KMail/1.9.9
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       linux-kernel@vger.kernel.org
References: <20080505182151.GE17139@cs181133002.pp.htv.fi>
In-Reply-To: <20080505182151.GE17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805051210.45579.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 05, 2008 11:21 am Adrian Bunk wrote:
> This patch makes the needlessly global {pciehp,shpchp}_slot_with_bus
> static.
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied to the linux-next branch of pci-2.6.  Thanks.

Jesse
