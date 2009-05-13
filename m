Return-Path: <linux-kernel-owner+w=401wt.eu-S1760354AbZEMOpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760354AbZEMOpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 10:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758736AbZEMOpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 10:45:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:40758 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760458AbZEMOpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 10:45:35 -0400
Subject: Re: [PATCH] Kconfig: CONFIG_UNEVICTABLE_LRU move into EMBEDDED
 submenu
From: David Woodhouse <dwmw2@infradead.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
In-Reply-To: <20090513143400.GC31071@waste.org>
References: <20090513172904.7234.A69D9226@jp.fujitsu.com>
	 <20090513175152.1590c117.minchan.kim@barrios-desktop>
	 <20090513175539.723A.A69D9226@jp.fujitsu.com>
	 <20090513191221.674bc543.minchan.kim@barrios-desktop>
	 <1242211037.24436.552.camel@macbook.infradead.org>
	 <20090513143400.GC31071@waste.org>
Content-Type: text/plain
Date: Wed, 13 May 2009 15:45:26 +0100
Message-Id: <1242225926.24436.611.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-13 at 09:34 -0500, Matt Mackall wrote:
> As the person who introduced CONFIG_EMBEDDED, I've occasionally
> thought we should rename it to CONFIG_NONSTANDARD to make the
> semantics clearer. It's less about cell phones and more about going
> way off the beaten path.

CONFIG_I_AM_NOT_AUNT_TILLIE

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

