Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbYC1Nib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbYC1Nib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 09:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbYC1NiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 09:38:22 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:49036 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752063AbYC1NiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 09:38:21 -0400
Date: Fri, 28 Mar 2008 09:38:20 -0400
To: David Brownell <david-b@pacbell.net>
Cc: mgross@linux.intel.com, Greg KH <greg@kroah.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: Real time USB2Serial devices and behaivor
Message-ID: <20080328133820.GH20025@csclub.uwaterloo.ca>
References: <20080326152559.GA17164@linux.intel.com> <200803271248.40519.david-b@pacbell.net> <20080327210036.GA20027@csclub.uwaterloo.ca> <200803271408.55930.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803271408.55930.david-b@pacbell.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 02:08:55PM -0700, David Brownell wrote:
> List price $117 ... 4-port for $202 ... you can buy entire
> computers for less!!  ;)
> 
> I really should have stocked up on the $5 cards...

Well the digi cards can run 460Kbps, which the $5 cards could not, and
they have 64byte FIFOs, not 16, and are more efficient to manage from
software.

Basically plain serial is dying out for the majority of users
(unfortunate for those of us that use plain serial a lot).

I didn't realize the digi cards cost that much.  We get our own serial
PCI cards made at work for less than that and they are industrial
temperature and we don't exactly do large volumes.  Of course by the
time the sales people add markup and all that they would cost at least
what the digi cards do.  :)

-- 
Len Sorensen
