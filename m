Return-Path: <linux-kernel-owner+w=401wt.eu-S1757875AbZJBR0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875AbZJBR0D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 13:26:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757853AbZJBR0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 13:26:01 -0400
Received: from kroah.org ([198.145.64.141]:57720 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757844AbZJBR0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 13:26:00 -0400
Date: Fri, 2 Oct 2009 10:23:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/30] 2.6.30.9-stable review
Message-ID: <20091002172337.GA12642@kroah.com>
References: <20091001233504.GA17709@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001233504.GA17709@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 04:35:04PM -0700, Greg KH wrote:
> NOTE:  This is going to be the last .30 kernel release unless something
> odd happens.  Everyone should move to the .31 kernel release soon.

<snip>

> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.30.9-rc1.gz
> and the diffstat can be found below.

I've pushed out a 2.6.30.9-rc3 now (-rc2 was pushed out a bit too early,
sorry), with 3 more patches from the original -rc1 patch.

It can be found at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.30.9-rc3.gz

thanks,

greg k-h
