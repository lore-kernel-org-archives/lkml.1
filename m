Return-Path: <linux-kernel-owner+w=401wt.eu-S1760613AbZBLU3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760613AbZBLU3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 15:29:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758945AbZBLU2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 15:28:36 -0500
Received: from kroah.org ([198.145.64.141]:58937 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758752AbZBLU2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 15:28:34 -0500
Date: Thu, 12 Feb 2009 11:41:31 -0800
From: Greg KH <greg@kroah.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [0/9] pohmelfs for drivers/staging
Message-ID: <20090212194130.GA16214@kroah.com>
References: <1234188162-14727-1-git-send-email-zbr@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234188162-14727-1-git-send-email-zbr@ioremap.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 05:02:33PM +0300, Evgeniy Polyakov wrote:
> Patch is against vanilla tree.

Looks great, I've now added this to the -staging tree and it will show
up in the next -next releases and is queued up to go to Linus for
2.6.30.

thanks,

greg k-h
