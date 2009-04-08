Return-Path: <linux-kernel-owner+w=401wt.eu-S932434AbZDHQyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434AbZDHQyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 12:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757457AbZDHQyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 12:54:35 -0400
Received: from kroah.org ([198.145.64.141]:58989 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757130AbZDHQyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 12:54:35 -0400
Date: Wed, 8 Apr 2009 09:51:10 -0700
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] MAINTAINERS - Add file patterns
Message-ID: <20090408165110.GA32400@kroah.com>
References: <1239167872-8179-1-git-send-email-joe@perches.com> <1239167872-8179-3-git-send-email-joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239167872-8179-3-git-send-email-joe@perches.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 10:17:44PM -0700, Joe Perches wrote:
>  DRIVER CORE, KOBJECTS, AND SYSFS
>  P:	Greg Kroah-Hartman
>  M:	gregkh@suse.de
>  L:	linux-kernel@vger.kernel.org
>  T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
>  S:	Supported
> +F:	Documentation/kobject.txt
> +F:	drivers/base/core.c

That should be drivers/base*

thanks,

greg k-h
