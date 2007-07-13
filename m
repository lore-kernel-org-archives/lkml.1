Return-Path: <linux-kernel-owner+w=401wt.eu-S932319AbXGMNWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319AbXGMNWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 09:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760102AbXGMNVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 09:21:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44688 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759719AbXGMNVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 09:21:38 -0400
Date: Fri, 13 Jul 2007 14:21:37 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, xfs@oss.sgi.com, tytso@mit.edu,
       cmm@us.ibm.com, suparna@in.ibm.com, adilger@clusterfs.com, dgc@sgi.com
Subject: Re: [PATCH 3/6][TAKE7] revalidate write permissions for fallocate
Message-ID: <20070713132137.GB23256@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, tytso@mit.edu,
	cmm@us.ibm.com, suparna@in.ibm.com, adilger@clusterfs.com,
	dgc@sgi.com
References: <20070713123816.GA18000@amitarora.in.ibm.com> <20070713124847.GC22961@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713124847.GC22961@amitarora.in.ibm.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 06:18:47PM +0530, Amit K. Arora wrote:
> From: David P. Quigley <dpquigl@tycho.nsa.gov>
> 
> Revalidate the write permissions for fallocate(2), in case security policy has
> changed since the files were opened.
> 
> Acked-by: James Morris <jmorris@namei.org>
> Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>

This should be merged into the main falloc patch.

