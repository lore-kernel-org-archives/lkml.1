Return-Path: <linux-kernel-owner+w=401wt.eu-S1752733AbXLXTUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbXLXTUh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 14:20:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbXLXTU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 14:20:27 -0500
Received: from lixom.net ([66.141.50.11]:42141 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbXLXTU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 14:20:26 -0500
Date: Mon, 24 Dec 2007 13:27:29 -0600
From: Olof Johansson <olof@lixom.net>
To: Greg KH <gregkh@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       balbir@linux.vnet.ibm.com
Subject: Re: Build breakage on powerpc with 2.6.24-rc6-mm1
Message-ID: <20071224192729.GA3122@lixom.net>
References: <20071223224158.GA7975@linux.vnet.ibm.com> <20071224134353.c00fc231.sfr@canb.auug.org.au> <20071224044912.GA10690@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071224044912.GA10690@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2007 at 08:49:12PM -0800, Greg KH wrote:
> > Hi Greg, do you even build with your patches applied?
> 
> For the power architecture, no, I do not.  I used to, but my cross-build
> box died and I haven't taken the time to set it all up again.

Crosstool makes it really easy. It's demo-powerpc-970.sh will build a
toolchain that can build both 32- and 64-bit powerpc kernels. It's got
a demo-s390.sh as well, but I haven't tried that one myself.


-Olof

