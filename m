Return-Path: <linux-kernel-owner+w=401wt.eu-S1751529AbZHaOBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbZHaOBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 10:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751010AbZHaOBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 10:01:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:6007 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbZHaOBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 10:01:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="182352753"
Date: Mon, 31 Aug 2009 22:01:13 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Fernando Silveira <fsilveira@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: I/O and pdflush
Message-ID: <20090831140113.GA24005@localhost>
References: <6afc6d4a0907111027w76234c8fv11ab77864515fdb0@mail.gmail.com> <20090712080410.GA8512@localhost> <6afc6d4a0908281448s537aa315jcb79b27453cf4279@mail.gmail.com> <20090829101247.GA20786@localhost> <20090829102126.GA22409@localhost> <6afc6d4a0908310624j47f9d8c7h47d98ecd95811883@mail.gmail.com> <20090831140006.GA23668@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090831140006.GA23668@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 10:00:06PM +0800, Wu Fengguang wrote:
> Hi Fernando,
> 
> What's your SSD's IO parameters? Ie. output of this command:
> 
>         grep -r . /sys/block/sda/queue/        
> 
> Please replace 'sda' with your SSD device name.

Oh I guess it's sdc:

         grep -r . /sys/block/sdc/queue/        

Thanks,
Fengguang

