Return-Path: <linux-kernel-owner+w=401wt.eu-S1756410AbYDRKcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410AbYDRKcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 06:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYDRKcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 06:32:15 -0400
Received: from relay2.globalproof.net ([194.146.153.25]:54021 "EHLO
	relay2.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbYDRKcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 06:32:14 -0400
From: Denys Fedoryshchenko <denys@visp.net.lb>
Organization: Virtual ISP S.A.L.
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.25 released with bug, which leads to XFS crash?
Date: Fri, 18 Apr 2008 13:32:30 +0300
User-Agent: KMail/1.9.5
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-kernel@vger.kernel.org
References: <200804170949.36864.denys@visp.net.lb> <4807EDD6.8000705@sandeen.net> <20080418074041.GA9839@infradead.org>
In-Reply-To: <20080418074041.GA9839@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804181332.31177.denys@visp.net.lb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AUFS(same as COSS, UFS, NULL) is way of handling with cache storage in squid, and nothing else. It is userspace and not involved deeply with kernel things.
Since long long time i didn't had any single problem with it.
Kernel is fully vanilla.

On Friday 18 April 2008 10:40, Christoph Hellwig wrote:
> On Thu, Apr 17, 2008 at 07:39:50PM -0500, Eric Sandeen wrote:
> > Denys Fedoryshchenko wrote:
> > > Hi again
> > > 
> > > I reported about http://bugzilla.kernel.org/show_bug.cgi?id=10421 , and it is triggerable on different loaded servers with XFS (squid with aufs),
> > 
> > Oh, aufs was not listed in the bug report.  that's an out of tree
> > module, right?  Is it completely up to date and safe with 2.6.25?
> 
> And it's a completely crappy one.  I personally would through away every
> bug report with that piece of junk involved.
> 
> 

-- 
------
Technical Manager
Virtual ISP S.A.L.
Lebanon
