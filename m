Return-Path: <linux-kernel-owner+w=401wt.eu-S1754667AbZKQKAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbZKQKAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 05:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754275AbZKQKAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 05:00:47 -0500
Received: from smtp.nokia.com ([192.100.122.233]:32869 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172AbZKQKAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 05:00:46 -0500
Subject: Re: linux-next: manual merge of the omap_dss2 tree with the omap
 tree
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: ext Tony Lindgren <tony@atomide.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       ext Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20091116183425.GN3684@atomide.com>
References: <20091116160402.deb0cc82.sfr@canb.auug.org.au>
	 <1258366001.2384.25.camel@tubuntu.research.nokia.com>
	 <20091116183425.GN3684@atomide.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Nov 2009 12:00:31 +0200
Message-ID: <1258452031.2419.2.camel@tubuntu.research.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Nov 2009 10:00:36.0772 (UTC) FILETIME=[CF6E4640:01CA676C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-16 at 19:34 +0100, ext Tony Lindgren wrote:
> Tomi, please update your patch by leaving out the now unnecessary
> TWL4030 and regulator sections. See also the updated version of
> your patch attached.

Thanks, updated. Now I'm able to merge linux-omap/for-next and
dss/for-next without conflicts.

 Tomi


