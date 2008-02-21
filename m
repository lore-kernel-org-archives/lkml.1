Return-Path: <linux-kernel-owner+w=401wt.eu-S1763014AbYBUBtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763014AbYBUBtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 20:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbYBUBtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 20:49:04 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:38512 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbYBUBtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 20:49:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=b+/hp9zG1i2hD+F0EXXwPVkX5tLuJB+DEtkXETyCoZX+eTwy5DFg6S3fDPI3K7zPCUvXGGA9UWFKlIEW8HsHy1QP7GxuRrkwZ1ySqPVZpI2XMKiQZgnQJwvnVsTX7GF8ZfaZoNtPAV4nFfpsYvn8GOCHxjO8lmCQoE0gLi0gnVM=
Message-ID: <b6a2187b0802201749i950b2aeue10993722a3880c1@mail.gmail.com>
Date: Thu, 21 Feb 2008 09:49:00 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Jesse Barnes" <jesse.barnes@intel.com>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, "Dave Airlie" <airlied@linux.ie>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       "suspend-devel List" <suspend-devel@lists.sourceforge.net>,
       "Greg KH" <gregkh@suse.de>
In-Reply-To: <200802201721.21353.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com>
	 <200802201639.02502.jesse.barnes@intel.com>
	 <b6a2187b0802201719x39a1298j970c563a17fe6a22@mail.gmail.com>
	 <200802201721.21353.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 9:21 AM, Jesse Barnes <jesse.barnes@intel.com> wrote:

>  > I hope those are just warning that can just be ignored.
>
>  Oops again, should be dev->pdev.  Silly DRM layer obfuscation.

I was just about to write that the test didn't work. Both std str
hangs even before attempting to suspend.

Anyway, I'm compiling and rebooting now.

Thanks,
Jeff.
