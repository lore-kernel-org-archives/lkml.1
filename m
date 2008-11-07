Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbYKGCAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbYKGCAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 21:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbYKGCAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 21:00:42 -0500
Received: from kroah.org ([198.145.64.141]:51920 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750894AbYKGCAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 21:00:41 -0500
Date: Thu, 6 Nov 2008 17:58:44 -0800
From: Greg KH <greg@kroah.com>
To: H L <swdevyid@yahoo.com>
Cc: Yu Zhao <yu.zhao@intel.com>, randy.dunlap@oracle.com,
       grundler@parisc-linux.org, achiang@hp.com, matthew@wil.cx,
       linux-pci@vger.kernel.org, rdreier@cisco.com,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       mingo@elte.hu, Xen-devel List <xen-devel@lists.xensource.com>
Subject: Re: git repository for SR-IOV development?
Message-ID: <20081107015844.GA11884@kroah.com>
References: <20081106165914.GA13476@kroah.com> <104014.9320.qm@web45110.mail.sp1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <104014.9320.qm@web45110.mail.sp1.yahoo.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 11:58:25AM -0800, H L wrote:
> --- On Thu, 11/6/08, Greg KH <greg@kroah.com> wrote:
> 
> > On Thu, Nov 06, 2008 at 08:51:09AM -0800, H L wrote:
> > > 
> > > Has anyone initiated or given consideration to the
> > creation of a git
> > > repository (say, on kernel.org) for SR-IOV
> > development?
> > 
> > Why?  It's only a few patches, right?  Why would it
> > need a whole new git
> > tree?
> 
> 
> So as to minimize the time and effort patching a kernel, especially if
> the tree (and/or hash level) against which the patches were created
> fails to be specified on a mailing-list.  Plus, there appears to be
> questions raised on how, precisely, the implementation should
> ultimately be modeled and especially given that, who knows at this
> point what number of patches will ultimately be submitted?  I know
> I've built the "7-patch" one (painfully, by the way), and I'm aware
> there's another 15-patch set out there which I've not yet examined.

It's a mere 7 or 15 patches, you don't need a whole git tree for
something small like that.

Especially as there only seems to be one developer doing real work...

thanks,

greg k-h
