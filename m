Return-Path: <linux-kernel-owner+w=401wt.eu-S933153AbXA3KkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153AbXA3KkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 05:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933156AbXA3KkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 05:40:24 -0500
Received: from verein.lst.de ([213.95.11.210]:36506 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933153AbXA3KkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 05:40:23 -0500
Date: Tue, 30 Jan 2007 11:39:25 +0100
From: Christoph Hellwig <hch@lst.de>
To: Maynard Johnson <maynardj@us.ibm.com>
Cc: cbe-oss-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, oprofile-list@lists.sourceforge.net
Subject: Re: [Cbe-oss-dev] [RFC, PATCH 1/4] Add support to OProfile for profiling Cell BE SPUs -- update
Message-ID: <20070130103924.GA14571@lst.de>
References: <45BE4ED0.5030808@us.ibm.com> <45BE4F2A.5040702@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BE4F2A.5040702@us.ibm.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 01:46:50PM -0600, Maynard Johnson wrote:
> 
> 

I don't think the macro removal is helpful, getting rid of the names
makes the code less readable to me.
