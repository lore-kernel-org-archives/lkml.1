Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbZBRTmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbZBRTmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 14:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbZBRTmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 14:42:04 -0500
Received: from kroah.org ([198.145.64.141]:34042 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751379AbZBRTmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 14:42:01 -0500
Date: Wed, 18 Feb 2009 11:40:07 -0800
From: Greg KH <greg@kroah.com>
To: Teck Choon Giam <giamteckchoon@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Reference to inexistent struct dmi_device_id breaks the build
	into 2.6.28-stable
Message-ID: <20090218194007.GA26837@kroah.com>
References: <9b5c9bb30902172334o1ae3951i7daf4de65b428434@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b5c9bb30902172334o1ae3951i7daf4de65b428434@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 03:34:51PM +0800, Teck Choon Giam wrote:
> Hi,
> 
> Sorry if this is not the right place to ask.  I am curious about when
> the "Reference to inexistent struct dmi_device_id breaks the build"
> (http://bugzilla.kernel.org/show_bug.cgi?id=12483) fix going into
> 2.6.28-stable tree?  I just checked 2.6.28.6 and it isn't there.

No one has submitted it to the stable@kernel.org address for them to
know to pick this up :(

I'll go take care of it...

thanks,

greg k-h
