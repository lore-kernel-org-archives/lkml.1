Return-Path: <linux-kernel-owner+w=401wt.eu-S1756788AbYF0Eba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbYF0Eba (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 00:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYF0EbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 00:31:21 -0400
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:25833 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750806AbYF0EbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 00:31:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEANexXkh5LFnm/2dsb2JhbACuPg
X-IronPort-AV: E=Sophos;i="4.27,713,1204464600"; 
   d="scan'208";a="144217243"
Date: Fri, 27 Jun 2008 14:31:13 +1000
From: Dave Chinner <david@fromorbit.com>
To: Oliver Pinter <oliver.pntr@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [XFS] kernel panic on halt (2.6.26-rc7)
Message-ID: <20080627043113.GZ29319@disturbed>
Mail-Followup-To: Oliver Pinter <oliver.pntr@gmail.com>,
	Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
	linux-kernel@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>,
	Matthew Wilcox <matthew@wil.cx>
References: <6101e8c40806260532j3bed1c7k9a60c41ea297549f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6101e8c40806260532j3bed1c7k9a60c41ea297549f@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 02:32:19PM +0200, Oliver Pinter wrote:
> Hi Christoph, Dave,
> 
> a similar problem came out the with 2.6.26, than the was in post early
> with 2.6.25[1][2]
> 
> http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00807.jpg
> http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00808.jpg
> http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00809.jpg
> http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00810.jpg
> http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00811.jpg

http://lkml.org/lkml/2008/3/7/356

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
