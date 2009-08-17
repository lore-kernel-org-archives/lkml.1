Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbZHQWnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbZHQWnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 18:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbZHQWnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 18:43:23 -0400
Received: from kroah.org ([198.145.64.141]:41613 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbZHQWnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 18:43:23 -0400
Date: Mon, 17 Aug 2009 15:42:03 -0700
From: Greg KH <greg@kroah.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: usbutils 0.86 release
Message-ID: <20090817224203.GA6111@kroah.com>
References: <20090817223626.GA5826@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090817223626.GA5826@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17, 2009 at 03:36:26PM -0700, Greg KH wrote:
> Here's the 0.86 release of usbutils.
> 
> There's a few minor fixups for the usb-devices script, as well as a
> patch to help make fetching HID descriptors a bit more robust.
> 
> And a number of build configuration fixes as well.
> 
> The tarballs can be downloaded from sf.net at:
> 	https://sourceforge.net/project/showfiles.php?group_id=3581
> 
> Or directly from kernel.org now:
> 	http://www.kernel.org/pub/linux/utils/usb/usbutils/

Ok, I take that back, they can't be downloaded from the sf.net site as I
can't figure out how to upload a new version there with the "improved"
interface they have now provided.

So for the near future, usbutils releases will be found on kernel.org as
it's just so damm simpler than a 4-part multi-form-javascript-lunacy
that sf.net seems to now rely on.

thanks,

greg k-h
