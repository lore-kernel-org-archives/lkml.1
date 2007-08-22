Return-Path: <linux-kernel-owner+w=401wt.eu-S1764014AbXHVPFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764014AbXHVPFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 11:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762810AbXHVPFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 11:05:30 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39636 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761216AbXHVPF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 11:05:29 -0400
Date: Wed, 22 Aug 2007 10:25:11 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [RFC][PATCH -mm 1/4] Hibernation: Arbitrary boot kernel support - generic code
Message-ID: <20070822082511.GA2479@elf.ucw.cz>
References: <200708221015.16493.rjw@sisk.pl> <200708221017.13111.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708221017.13111.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2007-08-22 10:17:12, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Add the bits needed for supporting arbitrary boot kernels to the common
> hibernation code.
> 
> To support arbitrary boot kernels, make it possible to replace the 'struct
> new_utsname' and the kernel version in the hibernation image header by some
> architecture specific data that will be used to verify if the image is valid
> and to restore the image.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
