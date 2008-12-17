Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752407AbYLQT67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbYLQT67 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 14:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbYLQT6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 14:58:46 -0500
Received: from kroah.org ([198.145.64.141]:35605 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751101AbYLQT6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 14:58:45 -0500
Date: Wed, 17 Dec 2008 11:51:43 -0800
From: Greg KH <greg@kroah.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Rose, Gregory V" <gregory.v.rose@intel.com>,
        Jike Song <albcamus@gmail.com>, "Zhao, Yu" <yu.zhao@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "achiang@hp.com" <achiang@hp.com>,
        "bjorn.helgaas@hp.com" <bjorn.helgaas@hp.com>,
        "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "matthew@wil.cx" <matthew@wil.cx>,
        "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
        "rdreier@cisco.com" <rdreier@cisco.com>,
        "horms@verge.net.au" <horms@verge.net.au>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 0/13 v7] PCI: Linux kernel SR-IOV support
Message-ID: <20081217195143.GA25211@kroah.com>
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com> <200812171051.36645.jbarnes@virtuousgeek.org> <43F901BD926A4E43B106BF17856F07554B525A02@orsmsx508.amr.corp.intel.com> <200812171142.56170.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812171142.56170.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 11:42:54AM -0800, Jesse Barnes wrote:
> 
> I really don't want the SR-IOV stuff to sit out another merge cycle though...  
> Arg.

Why, is there some rush to get it in?  As there is no in-kernel users of
it, I don't see the problem with postponing it until someone actually
needs it.

thanks,

greg k-h
