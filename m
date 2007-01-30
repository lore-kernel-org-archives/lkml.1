Return-Path: <linux-kernel-owner+w=401wt.eu-S1751252AbXA3UPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252AbXA3UPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 15:15:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbXA3UPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 15:15:15 -0500
Received: from an-out-0708.google.com ([209.85.132.241]:35554 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbXA3UPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 15:15:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PikOMWdD/z0ve/2MNMste61LONYkVv7BS/yhv4TH9g78wlPhU9bPHMzpG+A/M59AQZI1qlmajhMD7HpVMOhjaSJr03Lf0HsCo41lZnQx72CskWsfFJ6VQJuKecLXt96p5xuJyLqkaME92HS3d1vWxVyuFuAfWXaFFjhnQA+gSzI=
Message-ID: <f4527be0701301215q11924e3fnaaa5f33e6b6c5b36@mail.gmail.com>
Date: Tue, 30 Jan 2007 20:15:11 +0000
From: "Andrew Lyon" <andrew.lyon@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: Free Linux Driver Development!
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070130012904.GA9617@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070130012904.GA9617@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/30/07, Greg KH <greg@kroah.com> wrote:
> Free Linux Driver Development!
>
> Yes, that's right, the Linux kernel community is offering all companies
> free Linux driver development.  No longer do you have to suffer through
> all of the different examples in the Linux Device Driver Kit, or pick
> through the thousands of example drivers in the Linux kernel source
> tree trying to determine which one is the closest to what you need to
> do.
>
> All that is needed is some kind of specification that describes how your
> device works, or the email address of an engineer that is willing to
> answer questions every once in a while.  A few sample devices might be
> good to have so that debugging doesn't have to be done by email, but if
> necessary, that can be done.
>
> In return, you will receive a complete and working Linux driver that is
> added to the main Linux kernel source tree.  The driver will be written
> by some of the members of the Linux kernel developer community (over
> 1500 strong and growing).  This driver will then be automatically
> included in all Linux distributions, including the "enterprise" ones.
> It will be automatically kept up to date and working through all Linux
> kernel API changes.  This driver will work with all[1] of the different
> CPU types supported by Linux, the largest number of CPU types supported
> by any operating system ever before in the history of computing.
>
> As for support, the driver will be supported through email by the
> original developers, when they can help out, and by the "enterprise"
> Linux distributors as part of their service agreements with their
> customers.
>
> If your company is worried about NDA issues surrounding your device's
> specifications, we have arranged a program with OSDL/TLF's Tech Board to
> provide the legal framework where a company can interact with a member
> of the kernel community in order to properly assure that all needed NDA
> requirements are fulfilled.
>
> Now your developers will have more time to work on drivers for all of
> the other operating systems out there, and you can add "supported on
> Linux" to your product's marketing material.
>
> This offer is in affect for all different types of devices, from USB
> toys to PCI video devices to high-speed networking cards.  If you build
> it, we can get Linux drivers working for it.
>
> For any questions about this program, please feel free to respond to
> this email, or contact me directly at greg@kroah.com.  I will also be
> available at FreedomHEC 2007 <http://freedomhec.pbwiki.com/> held
> adjacent to WinHEC, if anyone wants to bring devices and work
> face-to-face.
>
> thanks,
>
> greg k-h
>
> [1] for the CPUs that support the bus types that your device works on.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

How about a kernel driver for the m-cubed tbalancer bigNG ?

http://www.t-balancer.com/english/bng.htm  (see support section of site)

Complete documentation is available, and devs are friendly (see
forums), there is already a userspace utility that works well but a
kernel driver would be even better, especially for something that
controls system cooling!

Andy
