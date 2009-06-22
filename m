Return-Path: <linux-kernel-owner+w=401wt.eu-S1756966AbZFVVOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966AbZFVVOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 17:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbZFVVON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 17:14:13 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:59054 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbZFVVOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 17:14:12 -0400
Subject: Re: [PATCH -next] hwlat: depends on RING_BUFFER (build fix)
From: Jon Masters <jonathan@jonmasters.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Jon Masters <jcm@jonmasters.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4A3FA899.3040402@oracle.com>
References: <20090622181920.496d160e.sfr@canb.auug.org.au>
	 <4A3FA899.3040402@oracle.com>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Mon, 22 Jun 2009 17:14:11 -0400
Message-Id: <1245705251.15044.32.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 08:51 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> hwlat_detector build fails because it uses ring_buffer interfaces
> without depending on RING_BUFFER.

Thanks randy, I'll pull that in to my for-linus tree. Hope to see you in
Montreal/Portland ;)

Jon.


