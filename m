Return-Path: <linux-kernel-owner+w=401wt.eu-S934493AbYBOA2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934493AbYBOA2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 19:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761071AbYBOA2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 19:28:09 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:54788 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755693AbYBOA2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 19:28:05 -0500
Subject: Re: [PATCH resend] ext2/3/4: convert byte order of constant
	instead of variable
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20080214142015.f59a9e21.akpm@linux-foundation.org>
References: <20080210101010.GB6737@joi>
	 <20080214142015.f59a9e21.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Thu, 14 Feb 2008 16:27:55 -0800
Message-Id: <1203035275.3637.71.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-14 at 14:20 -0800, Andrew Morton wrote:
> On Sun, 10 Feb 2008 11:10:15 +0100
> Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> 
> >  fs/ext2/super.c |    8 +++-----
> >  fs/ext3/super.c |    2 +-
> >  fs/ext4/super.c |    2 +-
> 
> Please don't bundle the filesystem patches in this manner.  I split
> it into three patches.
> 
Andrew, Ted,

I added the ext4 patch in the ext4 patch queue.

Regards,
Mingming


