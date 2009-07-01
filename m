Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbZGASP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbZGASP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 14:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbZGASPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 14:15:20 -0400
Received: from kroah.org ([198.145.64.141]:52142 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748AbZGASPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 14:15:19 -0400
Date: Wed, 1 Jul 2009 11:10:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 000/108] 2.6.30-stable review
Message-ID: <20090701181034.GA3491@kroah.com>
References: <20090701002838.GA7100@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701002838.GA7100@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 05:28:38PM -0700, Greg KH wrote:
> This is the start of the stable review cycle for the 2.6.30.1 release.

Ok, we had some kvm issues with the -rc1 kernel, so there is a -rc2
kernel out now.  It can be found at:

	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.30.1-rc2.gz

The full diffstat is below, and here is what has changed:
	- removed 3 kvm patches
	- added 1 kvm patch to replace the removed ones
	- added 3 more patches, they will be sent to the list now.

thanks,

greg k-h
