Return-Path: <linux-kernel-owner+w=401wt.eu-S1752873Ab0AHHu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab0AHHu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 02:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715Ab0AHHu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 02:50:59 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:33579 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab0AHHu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 02:50:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tWRV0x9qceLYjb1CdkUPXrbNbpepxBmA2EHwHpA8rgFt4BQxEAaL6Ycbc3sWgGJvqk
         i7oEgUBCCxMnwTV1lLqlTs0W7orb0VPGcIBQ/gqukbIt1jEghzIlTX/bsMzbwf6mbUC/
         xd0FnK+bMSBvlmwEuA/MOWJpazqs4tEAaG880=
Date: Thu, 7 Jan 2010 23:50:54 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Benjamin Valentin <benpicco@zedat.fu-berlin.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/input/joystick/xpad.c: Add rumble support for
 original xbox controller
Message-ID: <20100108075054.GA3696@core.coreip.homeip.net>
References: <20100108033215.447c814e@rechenknecht2k7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100108033215.447c814e@rechenknecht2k7>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

On Fri, Jan 08, 2010 at 03:32:15AM +0100, Benjamin Valentin wrote:
> This will add rumble support for xbox 1 compatible controllers.
> I am wondering why XTYPE_XBOX360W is excluded from the rumbling action,
> however as I have no device to test, I have not touched this.

Thank you for your patch. Could I please have your "Signed-off-by: " so
I can apply it? Also, if you have any more patches ofr in put devices,
could you please CC linux-input@vger.kernel.org?

Thanks!

-- 
Dmitry
