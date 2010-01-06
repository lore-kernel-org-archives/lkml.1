Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074Ab0AFSIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab0AFSIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 13:08:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756053Ab0AFSIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 13:08:51 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:42101 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032Ab0AFSIu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 13:08:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jO2c5FDTAEm3sjWaPZFrTAIf50REjn5hyMIXIOkxLVi0dOn40hM3TwRzSQ3It4iH8q
         gObrvR63ENkOzMqww9bPxEf4peO/k3rqmF1MLl1Y0138I2Mq/vPRHEYf/XXRqDh1/OJF
         BWGF3bwiUTs3WSBT2MBpBx4ms82N9YlP0ZG/g=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1001061747250.5372@casper.infradead.org>
References: <a44ae5cd1001060916s4db1d94fsb7e012ab80ce6add@mail.gmail.com>
	 <alpine.LFD.2.00.1001061736080.5372@casper.infradead.org>
	 <a44ae5cd1001060942p7672768yec3b1f5ea2426682@mail.gmail.com>
	 <alpine.LFD.2.00.1001061747250.5372@casper.infradead.org>
Date: Wed, 6 Jan 2010 13:08:47 -0500
Message-ID: <a44ae5cd1001061008l4c4dbfb8j9197d1809c621053@mail.gmail.com>
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

On Wed, Jan 6, 2010 at 12:48 PM, James Simmons <jsimmons@infradead.org> wrote:
>
>> On Wed, Jan 6, 2010 at 12:37 PM, James Simmons <jsimmons@infradead.org> wrote:
>> >
>> >> For a long time I have gotten two pictures of Tux showing up when I
>> >> include the Tux display option in my custom kernel builds.  I don't
>> >> know how many kernel revisions ago it was when I started noticing
>> >> this.  It seems like it might have been early in the 2.6 series
>> >> kernels.
>> >>
>> [...]
>> >> # Frame buffer hardware drivers
>> >> #
>> >> CONFIG_FB_VESA=y
>> >> CONFIG_FB_EFI=y
>> >
>> > Try disabling these two above options.

Okay.  I disabled those two options and still get the two Tuxes.  I
gues Bruno's message is correct, and I get two Tuxes because I have an
Atom processor with two cores.

               Miles
