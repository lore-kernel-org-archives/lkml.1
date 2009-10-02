Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbZJBFjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbZJBFjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 01:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756550AbZJBFjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 01:39:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:46388 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbZJBFjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 01:39:44 -0400
Subject: Re: [patch 1/4] dmar: support for parsing Remapping Hardware
 Static Affinity structure
From: David Woodhouse <dwmw2@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: jbarnes@virtuousgeek.org, len.brown@intel.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091001230743.949931468@sbs-t61.sc.intel.com>
References: <20091001230743.949931468@sbs-t61.sc.intel.com>
Content-Type: text/plain
Date: Fri, 02 Oct 2009 00:39:41 -0500
Message-Id: <1254461981.3218.1219.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-01 at 16:06 -0700, Suresh Siddha wrote:
> Add support for parsing Remapping Hardware Static Affinity (RHSA) structure.
> This enables identifying the association between remapping hardware units and
> the corresponding proximity domain. This enables to allocate transalation
> structures closer to the remapping hardware unit.

That's not going to apply on top of commit 17b6097753e, is it?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

