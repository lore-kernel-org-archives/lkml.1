Return-Path: <linux-kernel-owner+w=401wt.eu-S1762054AbYFGOzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762054AbYFGOzN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 10:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756629AbYFGOy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 10:54:58 -0400
Received: from ix.technologeek.org ([213.41.253.186]:55798 "EHLO
	sonic.technologeek.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756569AbYFGOy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 10:54:58 -0400
X-Greylist: delayed 554 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Jun 2008 10:54:57 EDT
From: Julien BLACHE <jb@jblache.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, rpurdie@rpsys.net,
       linux-kernel@vger.kernel.org, mzxreary@0pointer.de
Subject: Re: [PATCH v2] Add backlight driver for Nvidia-based Apple Macbook Pros
References: <20080607025436.GB24254@srcf.ucam.org>
	<20080606230745.304d116b.akpm@linux-foundation.org>
	<20080607100117.GB803@srcf.ucam.org>
Date: Sat, 07 Jun 2008 16:45:41 +0200
In-Reply-To: <20080607100117.GB803@srcf.ucam.org> (Matthew Garrett's message
	of "Sat, 7 Jun 2008 11:01:17 +0100")
Message-ID: <87tzg5tiay.fsf@sonic.technologeek.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett <mjg59@srcf.ucam.org> wrote:

Hi,

> Signed-off-by: Matthew Garrett <mjg@redhat.com>

If you need it, here you have it:

 Signed-off-by: Julien Blache <jb@jblache.org>

Minor nitpicks follow:

> +config BACKLIGHT_MBP_NVIDIA
> +       tristate "Macbook Pro Nvidia Backlight Driver"
                    ^^^^^^^   
Proper capitalization is "MacBook", also to be consistent with other
help texts in the kernel (I hope).

> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as
> + *  published by the Free Software Foundation.

This particular file in pommed is GPL v2 or later; it's external
code I included in pommed and the original license was GPL v2 or
later.

JB.

-- 
Julien BLACHE                                   <http://www.jblache.org> 
<jb@jblache.org>                                  GPG KeyID 0xF5D65169
