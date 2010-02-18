Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563Ab0BRQMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 11:12:37 -0500
Received: from kroah.org ([198.145.64.141]:60629 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758488Ab0BRQMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 11:12:31 -0500
Date: Thu, 18 Feb 2010 08:03:40 -0800
From: Greg KH <greg@kroah.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Bernhard Schiffner <bernhard@schiffner-limbach.de>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/3 V2] staging: r8187se: Miscellaneous cleanups
Message-ID: <20100218160340.GH21785@kroah.com>
References: <4b7963d0.cocDj1pGMQ3LKF4a%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b7963d0.cocDj1pGMQ3LKF4a%Larry.Finger@lwfinger.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 09:10:08AM -0600, Larry Finger wrote:
> This series of patches comprise further cleanups of the staging driver.
> 
> 1. Remove dead routine from r8180_core.c.
> 
> 2. Remove two private variables that have a fixed value.
> 
> 3. Remove dead code from r8185b_init.c.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Ick, I just applied your first versions of these patches.  What was the
difference here?  Care to look at the next linux-next tree and see if I
missed anything?

sorry about that.

greg k-h
