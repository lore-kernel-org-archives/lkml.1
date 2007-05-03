Return-Path: <linux-kernel-owner+w=401wt.eu-S1767341AbXECC4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767341AbXECC4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 22:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767344AbXECC4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 22:56:55 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:35293 "EHLO
	asav19.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767341AbXECC4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 22:56:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAM/rOEZKhRO4W2dsb2JhbACBZI4lHQ0GEA
From: Dmitry Torokhov <dtor@insightbb.com>
To: linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH] [RFC] Added USB_DEVICE_INTERFACE_PROTOCOL
Date: Wed, 2 May 2007 22:56:53 -0400
User-Agent: KMail/1.9.3
Cc: Greg KH <gregkh@suse.de>, Jan Kratochvil <honza@jikos.cz>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>
References: <Pine.LNX.4.64.0705021702040.13550@twin.jikos.cz> <20070502220433.GB21015@suse.de>
In-Reply-To: <20070502220433.GB21015@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705022256.54552.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 May 2007 18:04, Greg KH wrote:
> On Wed, May 02, 2007 at 05:03:05PM +0200, Jan Kratochvil wrote:
> > The USB_DEVICE_INTERFACE_PROTOCOL will allow to match one interface
> > protocol of vendor specific device.
> > This macro is used in patch adding support for xbox360 to xpad.c
> > 
> > Signed-off-by: Jan Kratochvil <honza@jikos.cz>
> 
> I have no objection to this, other than you need an additional newline
> after the #define :)
> 
> Dmitry, I can take this through my tree, or you can take it through
> yours, as I think the other patches in this series depend on this.
> 
> If you want to take it through yours, feel free to add:
> 	Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 

I will grab it once some issues with the patch set are resolved.

Thanks,

-- 
Dmitry
