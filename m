Return-Path: <linux-kernel-owner+w=401wt.eu-S1751468AbZGXAXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbZGXAXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 20:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbZGXAXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 20:23:45 -0400
Received: from kroah.org ([198.145.64.141]:44607 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbZGXAXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 20:23:44 -0400
Date: Thu, 23 Jul 2009 17:23:02 -0700
From: Greg KH <greg@kroah.com>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
       charles.f.johnson@intel.com
Subject: Re: [PATCH] Restricted access regions register driver revision 2
Message-ID: <20090724002302.GB26267@kroah.com>
References: <1248388236-13910-1-git-send-email-mark.a.allyn@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248388236-13910-1-git-send-email-mark.a.allyn@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23, 2009 at 03:30:36PM -0700, Mark Allyn wrote:
>  Upstream revision 2 of the restricted access memory registry
>  kernel driver;
> 
>  For the upstream community, this is revision 2. Changes are the
>  relocation of this driver to the staging area.

Your patch does not move the driver to drivers/staging/ at all, so you
might wish to respin this :)

thanks,

greg k-h
