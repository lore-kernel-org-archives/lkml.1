Return-Path: <linux-kernel-owner+w=401wt.eu-S1765177AbXILNAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765177AbXILNAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 09:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933801AbXILNAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 09:00:44 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:57872 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933643AbXILNAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 09:00:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=b42sL58MqvAKp06KdL1YGAYeZlX3i2KwxjBmP4/TV4rXzSmkMll8eEzSvZDqA20UHp7j5Oo1DqsBGfrcTdOxTi1C70RQAR9V4Awuve054MNAzLSf7SXFo1DZ6ZxRxqzw8K3ztg10vg0aNayu4cu0aEQkXgsp+EuSNdfVnsWVSTU=
Message-ID: <9b9c8e900709120600n3ffa9b6fn1bd514672d2e9bc1@mail.gmail.com>
Date: Wed, 12 Sep 2007 15:00:41 +0200
From: "tx tox" <t0mc4t1@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: RE: boot hangs with SMP, USB storage, and ACPI
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 Lip 2006, 00:41, Eric Cooper <e...@cmu.edu> wrote:
> When I try toboota 2.6.17 kernel compiled forSMP(hyperthreading),
> it hangs early in thebootsequence (after printing "FreeingSMP
> alternatives").  The issue seems to be an interaction between a
> USB-storage device (an empty flash card reader built into the
> monitor) andACPI.
>
> It boots fine if I do any one of these:
>   - physically disconnect theUSBdevice
>   - disableUSBsupport in the BIOS
>   -bootwithacpi=ht
> but none of these is completely satisfactory.
>
> I'll happily supply more details, run tests, etc. if anyone is
> interested in looking at this.  Thanks, and please CC me if you
> respond.
>
> --
> Eric Cooper             e c c @ c m u . e d u


I have exactly the same problem
This happens whenever i boot machine with reader on
or usbstick plugged in.
It happens with newer kernels as well.
It is little bit annoying to reset machine just because i forgot
to switch off the printer which has card reader equipped ;)
some goofing with printks suggests ACPI as a place whenre it freezes.
But i got no proof for that.
Any suggestions are welcome.

Regards
/TomCat
