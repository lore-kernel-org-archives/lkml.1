Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884AbYAIPTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbYAIPTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 10:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbYAIPTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 10:19:38 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52704 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbYAIPTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 10:19:37 -0500
Date: Wed, 9 Jan 2008 07:18:46 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Dave Airlie <airlied@linux.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       hch@lst.de, ak@suse.de, pq@iki.fi, jbeulich@novell.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "x86: optimize page faults like all other
 achitectures and kill notifier cruft"
Message-ID: <20080109071846.5c672a5c@laptopd505.fenrus.org>
In-Reply-To: <alpine.DEB.0.82.0801090308230.9570@skynet.skynet.ie>
References: <alpine.DEB.0.82.0801090226240.9570@skynet.skynet.ie>
	<20080108190611.3b9c0760.akpm@linux-foundation.org>
	<alpine.DEB.0.82.0801090308230.9570@skynet.skynet.ie>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2008 03:17:37 +0000 (GMT)
Dave Airlie <airlied@linux.ie> wrote:

> So all distros with 2.6.24 kernels are useless to mmiotrace I don't
> see why leaving things as is until a suitable replacement mechanism
> can be used.. 

you work for a distro.. surely you can convince your own distro to carry this patch for one release?
Maybe if it's this important.. so can the others...

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
