Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891AbZCENl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbZCENl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754469AbZCENif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:38:35 -0500
Received: from verein.lst.de ([213.95.11.210]:46023 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755821AbZCENid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:38:33 -0500
Date: Thu, 5 Mar 2009 14:38:28 +0100
From: Christoph Hellwig <hch@lst.de>
To: Hannes Eder <hannes@hanneseder.net>
Cc: Felix Blyakher <felixb@sgi.com>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] xfs: make symbols static
Message-ID: <20090305133828.GB14854@lst.de>
References: <20090304183136.525.13769.stgit@f10box.hanneseder.net> <20090304183356.525.64082.stgit@f10box.hanneseder.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090304183356.525.64082.stgit@f10box.hanneseder.net>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 04, 2009 at 07:34:10PM +0100, Hannes Eder wrote:
> Instead of the keyword 'static' the macro 'STATIC' is used, so the
> symbols are still global with CONFIG_XFS_DEBUG.

Looks good.

