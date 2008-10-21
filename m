Return-Path: <linux-kernel-owner+w=401wt.eu-S1754975AbYJUSLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbYJUSLB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 14:11:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbYJUSKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 14:10:52 -0400
Received: from kroah.org ([198.145.64.141]:53446 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751841AbYJUSKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 14:10:52 -0400
Date: Tue, 21 Oct 2008 10:31:40 -0700
From: Greg KH <greg@kroah.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org,
       Heinz Mauelshagen <mauelshagen@redhat.com>,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Milan Broz <mbroz@redhat.com>,
       Kazuo Ito <ito.kazuo@oss.ntt.co.jp>,
       "Martin K. Petersen" <martin.petersen@oracle.com>, stable@kernel.org
Subject: Re: [stable] [git pull] Additional device-mapper patches for 2.6.28
Message-ID: <20081021173140.GA25302@kroah.com>
References: <20081021165901.GO5098@agk.fab.redhat.com> <20081021170436.GA25030@kroah.com> <Pine.LNX.4.64.0810211311320.13319@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810211311320.13319@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 01:12:49PM -0400, Mikulas Patocka wrote:
> 
> 
> On Tue, 21 Oct 2008, Greg KH wrote:
> 
> > On Tue, Oct 21, 2008 at 05:59:01PM +0100, Alasdair G Kergon wrote:
> > > Please pull from:
> > > 
> > >   master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git
> > >  
> > > to get the following additional device-mapper patches for 2.6.28:
> > 
> > Hm, as you copied stable@kernel.org, does that mean that some of these
> > are applicable to -stable releases?
> > 
> > thanks,
> > 
> > greg k-h
> 
> That "fix primary_pe race" should be considered for -stable.

After it goes into Linus's tree, can you send it to stable@kernel.org
with the git commit id?

thanks,

greg k-h
