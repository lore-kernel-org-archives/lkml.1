Return-Path: <linux-kernel-owner+w=401wt.eu-S1753093AbZGAHJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbZGAHJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 03:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbZGAHJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 03:09:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:65135 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957AbZGAHJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 03:09:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,322,1243839600"; 
   d="scan'208";a="426760241"
Message-ID: <4A4B0BB1.2010102@linux.intel.com>
Date: Wed, 01 Jul 2009 09:09:37 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Stefan Lippers-Hollmann <s.L-H@gmx.de>, linux-kernel@vger.kernel.org,
       avi@redhat.com, ying.huang@intel.com, stable@kernel.org
Subject: Re: patch kvm-add-vt-x-machine-check-support.patch added to	2.6.30-stable
 tree
References: <20090629184144.76C9948FD3@coco.kroah.org> <200907010053.40900.s.L-H@gmx.de> <20090630234206.GA22546@suse.de>
In-Reply-To: <20090630234206.GA22546@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Thanks, I was building without kvm enabled in my configs and missed this
> one.
> 
> I've added these two other patches and everything looks better.

If you prefer I also have an original patch which didn't depend on any
other KVM patches. But the other ones look harmless enough and it's probably
better to stay nearer mainline.

-Andi

