Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934722Ab0BZANa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 19:13:30 -0500
Received: from kroah.org ([198.145.64.141]:43499 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934711Ab0BZAN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 19:13:26 -0500
Date: Thu, 25 Feb 2010 15:58:21 -0800
From: Greg KH <greg@kroah.com>
To: Alessio Igor Bogani <abogani@texware.it>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: Cleanup useless headers
Message-ID: <20100225235821.GH24155@kroah.com>
References: <1267038495-13961-1-git-send-email-abogani@texware.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267038495-13961-1-git-send-email-abogani@texware.it>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 08:08:15PM +0100, Alessio Igor Bogani wrote:
> BKL isn't anymore present into these files thus it is no necessary still include smp_lock.h.
> ---

I need a "Signed-off-by:" in order to be able to apply a patch.

Care to resend this with it in it?

thanks,

greg k-h
