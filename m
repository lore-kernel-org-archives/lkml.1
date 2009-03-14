Return-Path: <linux-kernel-owner+w=401wt.eu-S1752239AbZCNMqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbZCNMqZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 08:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbZCNMqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 08:46:17 -0400
Received: from verein.lst.de ([213.95.11.210]:54840 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbZCNMqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 08:46:16 -0400
Date: Sat, 14 Mar 2009 13:45:11 +0100
From: Christoph Hellwig <hch@lst.de>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
       davem@davemloft.net, tony.luck@intel.com, ralf@linux-mips.org,
       kyle@mcmartin.ca, schwidefsky@de.ibm.com, viro@zeniv.linux.org.uk
Subject: Re: [PATCH] generic compat_sys_ustat
Message-ID: <20090314124511.GA23881@lst.de>
References: <20081121084105.GA7155@lst.de> <20081128090909.GA28299@lst.de> <49B80E9D.3@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B80E9D.3@sandeen.net>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 02:18:53PM -0500, Eric Sandeen wrote:
> 
> Looks like this got lost?

Al promised to take it via the vfs queue, so hopefully it 'll go in for
the next releases..

