Return-Path: <linux-kernel-owner+w=401wt.eu-S1760770AbYJITZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760770AbYJITZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 15:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbYJITZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 15:25:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:31822 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbYJITZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 15:25:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xxpbdcovYf62U60Js6rjCp77+6Rxalpt0FWLPiwjDmr/Vk6yaJ8uTwVmM6deSttpg+
         xuW2iZO6fYY50L3dHYDhvZYgp2ToR2cyVa+NXzVj7L1MWKn3jfDF5yM0P+Cdi41d4lxp
         w6st3FHxu51NZO6F9w2rZ6Mb4I1pY3fVNCpJ0=
Message-ID: <5767b9100810091225n2837a9e9r6fd6c84ad075190b@mail.gmail.com>
Date: Fri, 10 Oct 2008 03:25:24 +0800
From: "Conke Hu" <conke.hu@gmail.com>
To: "Ben Dooks" <ben-linux@fluff.org>
Subject: Re: s3c24xx nand: add command line partition table parsing support (resend)
Cc: Linux-arm-kernel@lists.arm.linux.org.uk,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>
In-Reply-To: <20081009162610.GJ435@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5767b9100809171813u7e26d516x12558a178b78f852@mail.gmail.com>
	 <20080918112703.GA25491@flint.arm.linux.org.uk>
	 <5767b9100809180855j58150b4ct4e2a4b9bb5ac7885@mail.gmail.com>
	 <5767b9100809180858r3bb9952el3bc76dab18930713@mail.gmail.com>
	 <5767b9100810090848q50f3adefj4b34f8433dba61d2@mail.gmail.com>
	 <20081009162610.GJ435@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben, could you please check the patch ?
thanks!

On Fri, Oct 10, 2008 at 12:26 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, Oct 09, 2008 at 11:48:51PM +0800, Conke Hu wrote:
>> Hi Russel,
>
> Grr.
>
>>     Is this one OK? we're looking forward to applying this patch :)
>
> Better people to ask would be the MTD people and Ben.  I'm not a
> gateway for every driver just because it's used on an ARM processor.
>
