Return-Path: <linux-kernel-owner+w=401wt.eu-S935286AbXGMO2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935286AbXGMO2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 10:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758483AbXGMO2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 10:28:38 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:46802 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452AbXGMO2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 10:28:37 -0400
Date: Fri, 13 Jul 2007 19:58:51 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       xfs@oss.sgi.com, tytso@mit.edu, cmm@us.ibm.com, suparna@in.ibm.com,
       adilger@clusterfs.com, dgc@sgi.com
Subject: Re: [PATCH 3/6][TAKE7] revalidate write permissions for fallocate
Message-ID: <20070713142851.GD27291@amitarora.in.ibm.com>
References: <20070713123816.GA18000@amitarora.in.ibm.com> <20070713124847.GC22961@amitarora.in.ibm.com> <20070713132137.GB23256@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713132137.GB23256@infradead.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 02:21:37PM +0100, Christoph Hellwig wrote:
> On Fri, Jul 13, 2007 at 06:18:47PM +0530, Amit K. Arora wrote:
> > From: David P. Quigley <dpquigl@tycho.nsa.gov>
> > 
> > Revalidate the write permissions for fallocate(2), in case security policy has
> > changed since the files were opened.
> > 
> > Acked-by: James Morris <jmorris@namei.org>
> > Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
> 
> This should be merged into the main falloc patch.

Ok. Will merge it...

--
Regards,
Amit Arora
