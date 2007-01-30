Return-Path: <linux-kernel-owner+w=401wt.eu-S1751935AbXA3WuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbXA3WuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 17:50:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbXA3WuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 17:50:03 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:52543 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbXA3WuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 17:50:00 -0500
Subject: Re: [Cbe-oss-dev] [RFC, PATCH 1/4] Add support to OProfile for
	profiling Cell BE SPUs -- update
From: Carl Love <cel@us.ibm.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Maynard Johnson <maynardj@us.ibm.com>, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org, oprofile-list@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070130103924.GA14571@lst.de>
References: <45BE4ED0.5030808@us.ibm.com> <45BE4F2A.5040702@us.ibm.com>
	 <20070130103924.GA14571@lst.de>
Content-Type: text/plain
Date: Tue, 30 Jan 2007 14:49:57 -0800
Message-Id: <1170197398.5235.12.camel@dyn9047021078.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph:

In our earlier work on the PPU profiling patch, Benjamin Herrenschmidt
said that we should remove macros that are only used once and just put
the actual code in.  That is why the macros were removed. 

            Carl Love


On Tue, 2007-01-30 at 11:39 +0100, Christoph Hellwig wrote:
> On Mon, Jan 29, 2007 at 01:46:50PM -0600, Maynard Johnson wrote:
> > 
> > 
> 
> I don't think the macro removal is helpful, getting rid of the names
> makes the code less readable to me.
> _______________________________________________
> cbe-oss-dev mailing list
> cbe-oss-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/cbe-oss-dev

