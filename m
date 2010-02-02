Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab0BBPXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 10:23:12 -0500
Received: from kroah.org ([198.145.64.141]:58111 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756225Ab0BBPXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 10:23:01 -0500
Date: Tue, 2 Feb 2010 07:22:53 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: linux-next: manual merge of the driver-core tree with the
	suspend tree
Message-ID: <20100202152253.GB15932@kroah.com>
References: <20100202170155.0fa4ce45.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100202170155.0fa4ce45.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 05:01:55PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> drivers/base/power/main.c between commit
> de20f9bde404252647645f9f948c8c5de16cc51d ("PM: Asynchronous suspend and
> resume of devices") from the suspend tree and commit
> df5a0aec4591ae8a5deb67bc8cb6be3d0812abb2 ("drivers/base: Convert dev->sem
> to mutex") from the driver-core tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Fix looks fine, thanks for doing this.

greg k-h
