Return-Path: <linux-kernel-owner+w=401wt.eu-S1759331AbZFJV2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759331AbZFJV2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbZFJV2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:28:42 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:40730 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbZFJV2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:28:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=dCWAhDT8GxcgGKuXASbEoPZhTajuStLx0M8RfZp2SHz7R0n9x5uwJ0C49ItD8EHN+p
         NRLWQKOeb8raPNOuXW7HVboAxr88c59QwLUxuQZziJQsAtK6BXPvnS+FBa4rtRzSi+bb
         KcTQpudMDnyJ5TiJ6zDn9uvpU3FkRT3OBAk4U=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: MSM6281 support was: HTC Dream aka. t-mobile g1 support
Date: Wed, 10 Jun 2009 23:28:39 +0200
User-Agent: KMail/1.9.9
Cc: Brian Swetland <swetland@google.com>,
       Stefan Schmidt <stefan@datenfreihafen.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       san@android.com, rlove@google.com
References: <20090610103131.GB13885@elf.ucw.cz> <20090610204708.GD6251@dodger.lab.datenfreihafen.org> <a55d774e0906101408t75e507f5s8064796b080828c2@mail.gmail.com>
In-Reply-To: <a55d774e0906101408t75e507f5s8064796b080828c2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906102328.40140.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 of June 2009 23:08:36 Brian Swetland wrote:
> On Wed, Jun 10, 2009 at 1:47 PM, Stefan
>
> Schmidt<stefan@datenfreihafen.org> wrote:
> > Hello.
> >
> > On Wed, 2009-06-10 at 13:24, Brian Swetland wrote:
> >> We have full support for MSM7201A, including fully functional power
> >> management, working on a number of commercially shipping devices that
> >> we'd absolutely love to get into mainline.
> >
> > A bit offtopic here. (subject change). Is it expected that the android
> > kernel team will also work on systems that use the MSM6K modems with
> > different SoC's? I have soem systems here that use an msm6281 on a dual
> > port ram chip with non msm SoC's. I wonder how difficult it would be to
> > adaept the existing msm smd driver to such a setup.
>
> We only have documentation, support, and permission to do work on 7k
> and 8k family devices at this point.  I don't know anything about the
> 6k family, and how similar (or not) the shared memory interface would
> be, so unfortunately I can't provide much help there.

Palm Pre apparently uses MSM68xx as a baseband chip, otherwise is omap3 based. 
The device is out, selling, but I haven't seen any kernel patches from them 
yet. I hope they release them in a few weeks (even though they should have 
been out already).
>
> Brian
>
> -------------------------------------------------------------------
> List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
> FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
> Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php


