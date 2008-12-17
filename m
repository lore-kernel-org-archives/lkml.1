Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752114AbYLQSSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbYLQSSY (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 13:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbYLQSRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 13:17:51 -0500
Received: from kroah.org ([198.145.64.141]:52443 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750890AbYLQSRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 13:17:49 -0500
Date: Wed, 17 Dec 2008 09:51:03 -0800
From: Greg KH <greg@kroah.com>
To: "Rose, Gregory V" <gregory.v.rose@intel.com>
Cc: Jike Song <albcamus@gmail.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Zhao, Yu" <yu.zhao@intel.com>,
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
Message-ID: <20081217175103.GA25562@kroah.com>
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com> <200812161523.55238.jbarnes@virtuousgeek.org> <49486602.5000108@gmail.com> <20081217060608.GA12618@kroah.com> <43F901BD926A4E43B106BF17856F07554B525811@orsmsx508.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43F901BD926A4E43B106BF17856F07554B525811@orsmsx508.amr.corp.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

On Wed, Dec 17, 2008 at 08:44:03AM -0800, Rose, Gregory V wrote:
> As noted in the attached email to the netdev list, we (e1000_devel) will support the API.

Great, will you have patches for the existing e1000 drivers soon to use
it?  Or will they be a while before they can be available?

As it is, the one posted user of this api is for a driver that has been
rejected, so as there are no users of the api, I feel it should be
deferrred until there is a user to make sure it all works and feels
proper.

thanks,

greg k-h
