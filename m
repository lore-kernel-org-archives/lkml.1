Return-Path: <linux-kernel-owner+w=401wt.eu-S1753986AbYJUROP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbYJUROP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 13:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbYJUROA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 13:14:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbYJURN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 13:13:59 -0400
Date: Tue, 21 Oct 2008 13:12:49 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Greg KH <greg@kroah.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org,
       Heinz Mauelshagen <mauelshagen@redhat.com>,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Milan Broz <mbroz@redhat.com>,
       Kazuo Ito <ito.kazuo@oss.ntt.co.jp>,
       "Martin K. Petersen" <martin.petersen@oracle.com>, stable@kernel.org
Subject: Re: [stable] [git pull] Additional device-mapper patches for 2.6.28
In-Reply-To: <20081021170436.GA25030@kroah.com>
Message-ID: <Pine.LNX.4.64.0810211311320.13319@hs20-bc2-1.build.redhat.com>
References: <20081021165901.GO5098@agk.fab.redhat.com> <20081021170436.GA25030@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 21 Oct 2008, Greg KH wrote:

> On Tue, Oct 21, 2008 at 05:59:01PM +0100, Alasdair G Kergon wrote:
> > Please pull from:
> > 
> >   master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git
> >  
> > to get the following additional device-mapper patches for 2.6.28:
> 
> Hm, as you copied stable@kernel.org, does that mean that some of these
> are applicable to -stable releases?
> 
> thanks,
> 
> greg k-h

That "fix primary_pe race" should be considered for -stable.

Mikulas
