Return-Path: <linux-kernel-owner+w=401wt.eu-S933173AbXA2HdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933173AbXA2HdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 02:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933118AbXA2HdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 02:33:19 -0500
Received: from nz-out-0506.google.com ([64.233.162.227]:20202 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933179AbXA2HdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 02:33:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BpQ35q6DgkOqm/AqQrTHh7WTB9pHiKzLifX5T2rCxrxZvobekksMXPDTLVCv4BkQv80Z8ZSyB7yW/J+uYSSp92p7ta8YPYkJ8w6eZib+FIMxXPk+2KnxF6hCNEXw5xO42ZKpt2okzrvfbpQY7DitjJrN+uuK952p6u+oMQy3SFM=
Message-ID: <8d158e1f0701282332m3e22a649s621abc258c6103d5@mail.gmail.com>
Date: Mon, 29 Jan 2007 08:32:43 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Boot problems with pata_via driver
In-Reply-To: <8d158e1f0701282330o3591a226lb664644ffdb025f0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8d158e1f0701280347l1d778528la0d69647726485d6@mail.gmail.com>
	 <20070128231147.GA6017@stusta.de>
	 <8d158e1f0701282330o3591a226lb664644ffdb025f0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/29/07, Patrick Ale <patrick.ale@gmail.com> wrote:
> On 1/29/07, Adrian Bunk <bunk@stusta.de> wrote:
> > On Sun, Jan 28, 2007 at 12:47:18PM +0100, Patrick Ale wrote:
>
> >
> > Hi Patrick,
>
  Morning!
  The 2.6.19 was self-compiled, using the gentoo-sources-rc4 AND using
  the vanilla 2.6.19 from kernel.org (I was recommended to use vanilla
  sources with my ATI drivers), both worked.

  2.6.20 is self compiled to. I will give you the kernel output when I
  am at home, I will have to connect a serial cable to my laptop and use
  the scrollbuffer since on a kernel panic or system crash my keyboard
  leds start to blink, which the kernel sees as a device addressing
  hardware directly and giving me a kernel message for every blink :D

  Oh, and pata_via is the ONLY driver I have compiled built-in,
  regarding libsata. As I mentioned in previous mails I have quite some
  controllers and disks, but pata_via (my onboard IDE) has only two
 drives attaches, on IDE0 (in 2.6.19 ata0) my boot disk

  I also tried to boot with scsi_mod.scan=sync, this didnt work either

  More info follows, thanks for your time allready :)


Patrick
