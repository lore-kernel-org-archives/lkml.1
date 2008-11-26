Return-Path: <linux-kernel-owner+w=401wt.eu-S1755118AbYKZRCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118AbYKZRCE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 12:02:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbYKZRBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 12:01:24 -0500
Received: from kroah.org ([198.145.64.141]:40243 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754321AbYKZRBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 12:01:22 -0500
Date: Wed, 26 Nov 2008 09:00:16 -0800
From: Greg KH <greg@kroah.com>
To: Yu Zhao <yu.zhao@intel.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [SR-IOV driver example 3/3] VF driver tar ball
Message-ID: <20081126170016.GC28251@kroah.com>
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com> <20081126140303.GA13641@yzhao12-linux.sh.intel.com> <20081126144043.GC13668@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126144043.GC13668@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 10:40:43PM +0800, Yu Zhao wrote:
> The attachment is the VF driver for Intel 82576 NIC.

Please don't attach things as tarballs, we can't review or easily read
them at all.

Care to resend it?

thanks,

greg k-h
