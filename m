Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbYI2PwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbYI2PwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 11:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbYI2Pvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 11:51:51 -0400
Received: from [198.145.64.141] ([198.145.64.141]:48375 "EHLO coco.kroah.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751423AbYI2Pvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 11:51:50 -0400
Date: Mon, 29 Sep 2008 08:43:59 -0700
From: Greg KH <greg@kroah.com>
To: Russ Anderson <rja@sgi.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       "H. Peter Anvin" <hpa@zytor.com>, Huang Ying <ying.huang@intel.com>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [PATCH 4/4] x86: Add sysfs entries for UV v2
Message-ID: <20080929154359.GB10741@kroah.com>
References: <20080926200343.GE138671@sgi.com> <20080928204701.GA5863@kroah.com> <20080928212834.GB17681@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080928212834.GB17681@sgi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2008 at 04:28:34PM -0500, Russ Anderson wrote:
> On Sun, Sep 28, 2008 at 01:47:01PM -0700, Greg KH wrote:
> > On Fri, Sep 26, 2008 at 03:03:43PM -0500, Russ Anderson wrote:
> > > [PATCH 4/4] Add sysfs entries for UV
> > > 
> > > Create /sys/firmware/sgi_uv sysfs entries for partition_id and coherence_id.
> > > The interface is documented in Documentation/ABI/testing/sysfs-firmware-sgi_uv.
> > 
> > It is?  I don't see that file in the patch:
> 
> It is already in Linus' tree.
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8b3a8944a9c0f2a3afc1678798b44f0442924a37

Heh you got the documentation in before the code, that seems to be an
interesting trend these days :)

thanks,

greg k-h
