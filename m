Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab0BBKol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 05:44:41 -0500
Received: from smtp.nokia.com ([192.100.122.233]:41924 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab0BBKoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 05:44:38 -0500
Subject: Re: UBIFS assert failed in ubifs_dirty_inode
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jeff Angielski <jeff@theptrgroup.com>
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
       linux-mtd@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B5FADE8.30803@theptrgroup.com>
References: <4B591573.60602@theptrgroup.com>
	 <1264480808.2401.78.camel@localhost.localdomain>
	 <1264484928.3536.1017.camel@calx> <1264500214.3867.21.camel@localhost>
	 <4B5F9A78.7080000@theptrgroup.com> <1264558433.3536.1543.camel@calx>
	 <4B5FADE8.30803@theptrgroup.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Feb 2010 12:42:15 +0200
Message-ID: <1265107335.4371.68.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 02 Feb 2010 10:43:45.0927 (UTC) FILETIME=[987EB970:01CAA3F4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-26 at 22:07 -0500, Jeff Angielski wrote:
... snip ...
> Matt's patch that removes the offending code works fine.
... snip ...

Jeff, I've pushed the patches from Herbert's tree to the ubifs back-port
trees (ubifs-v2.6.28 - ubifs-v2.6.32).

Thanks everyone.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

