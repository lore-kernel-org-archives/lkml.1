Return-Path: <linux-kernel-owner+w=401wt.eu-S1755447Ab0A0OzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab0A0OzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 09:55:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336Ab0A0OzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 09:55:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35550 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074Ab0A0OzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 09:55:23 -0500
Date: Wed, 27 Jan 2010 06:50:54 -0800
From: Greg KH <gregkh@suse.de>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Josh Boyer <jwboyer@gmail.com>,
       Stefani Seibold <stefani@seibold.net>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 0/3 for 2.6.33] Some fixes for kfifo and FHCI
Message-ID: <20100127145054.GA24673@suse.de>
References: <20100127140809.GA27906@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100127140809.GA27906@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 05:08:09PM +0300, Anton Vorontsov wrote:
> Hi all,
> 
> FHCI no longer builds after kfifo rework, this patch set is
> used to fix the issues.

If there are no objections to these, I'll queue these up and send them
through my tree as they affect the FHCI driver.

thanks,

greg k-h
