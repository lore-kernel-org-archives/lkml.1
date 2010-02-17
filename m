Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878Ab0BQXSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 18:18:15 -0500
Received: from kroah.org ([198.145.64.141]:43005 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757771Ab0BQXSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 18:18:11 -0500
Date: Wed, 17 Feb 2010 14:40:46 -0800
From: Greg KH <greg@kroah.com>
To: Josh Holland <jrh@joshh.co.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
       =?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
       devel@driverdevv.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: rar: More style changes to rar_driver.c
Message-ID: <20100217224046.GB31557@kroah.com>
References: <1265318585-24236-1-git-send-email-jrh@joshh.co.uk>
 <1265407106-19937-1-git-send-email-jrh@joshh.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265407106-19937-1-git-send-email-jrh@joshh.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 05, 2010 at 09:58:26PM +0000, Josh Holland wrote:
> Following advice from Krzysztof Halasa, I made a few changes to the
> style bits in rar_driver.c

Can you respin both of these patches in 2 days, against the linux-next
tree, as the rar driver author has sent in a bunch of "rename these
files" type patches, which caused these to not apply anymore.

thanks,

greg k-h
