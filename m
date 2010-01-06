Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015Ab0AFRnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab0AFRnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 12:43:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992Ab0AFRnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 12:43:06 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:40672 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706Ab0AFRnB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 12:43:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qvRAWC8O3KWn+VP4YRVE2d+lSFcQ1ycTfngWc6Th+EGI7J9sntKa9+yg3jNaB98yU+
         TEOVb1HCVHwoHDbi0U8mTFbBlz448htpQ/BGEF56ZhBrDnYyKwdao/Pk6zw/Br+bfqQ/
         YRC1OcJDJB2diouwEyFKV+jM3yk+MA8sIUvhg=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1001061736080.5372@casper.infradead.org>
References: <a44ae5cd1001060916s4db1d94fsb7e012ab80ce6add@mail.gmail.com>
	 <alpine.LFD.2.00.1001061736080.5372@casper.infradead.org>
Date: Wed, 6 Jan 2010 12:42:59 -0500
Message-ID: <a44ae5cd1001060942p7672768yec3b1f5ea2426682@mail.gmail.com>
Subject: Re: 2.6.33-rc3 -- Intel 945GME (inteldrmfb) -- Two Tux images 
	displayed are side by side (should only show one).
From: Miles Lane <miles.lane@gmail.com>
To: James Simmons <jsimmons@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
       Sylvain Meyer <sylvain.meyer@worldonline.fr>,
       linux-fbdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 6, 2010 at 12:37 PM, James Simmons <jsimmons@infradead.org> wrote:
>
>> For a long time I have gotten two pictures of Tux showing up when I
>> include the Tux display option in my custom kernel builds.  I don't
>> know how many kernel revisions ago it was when I started noticing
>> this.  It seems like it might have been early in the 2.6 series
>> kernels.
>>
[...]
>> # Frame buffer hardware drivers
>> #
>> CONFIG_FB_VESA=y
>> CONFIG_FB_EFI=y
>
> Try disabling these two above options.

Well, that means that I don't get Tux at all.  The point is that only
one copy should be displayed.

      Miles
