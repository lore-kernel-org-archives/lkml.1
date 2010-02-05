Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab0BEQxc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 11:53:32 -0500
Received: from kroah.org ([198.145.64.141]:40611 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754909Ab0BEQxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 11:53:30 -0500
Date: Fri, 5 Feb 2010 08:53:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [00/74] 2.6.32.8-stable review
Message-ID: <20100205165322.GA810@kroah.com>
References: <20100204171850.GA16539@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100204171850.GA16539@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 09:18:50AM -0800, Greg KH wrote:
> This is the start of the stable review cycle for the 2.6.32.8 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let us know.  If anyone is a maintainer of the proper subsystem, and
> wants to add a Signed-off-by: line to the patch, please respond with it.
> 
> Due to travelling to FOSDEM, I have not been able to test this release
> as well as I would have liked to.  Also, given the complexity of some of
> these changes, it would be great if people could really test this
> release to verify that it works properly.  All help here is greatly
> appreciated.
> 
> Responses should be made by Sunday, Feb 7 00:00:00 UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.32.8-rc1.gz
> and the diffstat can be found below.

Thanks to Jamal for fixing a boot-time problem in the -rc1 release, I've
now released a 2.6.32.8-rc2 patch at:
 	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.32.8-rc2.gz

If anyone who has had problems with the -rc1 release could test this
one, I would appreciate it.

thanks,

greg k-h
