Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171Ab0ASALj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab0ASALj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 19:11:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940Ab0ASALh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 19:11:37 -0500
Received: from kroah.org ([198.145.64.141]:57292 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846Ab0ASALe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 19:11:34 -0500
Date: Mon, 18 Jan 2010 16:10:45 -0800
From: Greg KH <greg@kroah.com>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
       charles.f.johnson@intel.com
Subject: Re: [PATCH] Add reference to memrar.h file
Message-ID: <20100119001045.GB27551@kroah.com>
References: <1263849759-23125-1-git-send-email-mark.a.allyn@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263849759-23125-1-git-send-email-mark.a.allyn@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 01:22:39PM -0800, Mark Allyn wrote:
> The purpose of this patch is to add raference to memrar.h

Why?  Does this fix something?  It sure doesn't add any new
functionality.  Is a later patch needing it?

If so, please number your patches so I know which ones to apply in which
order.

confused,

greg k-h
