Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbYIDGsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbYIDGsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 02:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYIDGsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 02:48:07 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:5835 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbYIDGsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 02:48:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Ous9lqHL1RsAvO0+DIockfrZYkdOrZsUaCpJORras1yQvmieT0cRYIXFh4n0hwHfpd
         nqsL1nvFfYv8+6eTNsdprHHVnygEAEw3rATNZ3Lo9oRz/ATUn3Npm2UjM3jPhkAitFG3
         qgMddsvOy9iPs9HnWiCzAwpntQlZhmgxBY/ns=
Message-ID: <71cd59b00809032348h7874167ckae1ea3d1ddab1e1c@mail.gmail.com>
Date: Thu, 4 Sep 2008 08:48:03 +0200
From: "Corentin Chary" <corentin.chary@gmail.com>
To: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Subject: Re: How to add the Asus R1F to asus-laptop.c?
Cc: "Alistair John Strachan" <alistair@devzero.co.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080903203954.GT12474@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080903170649.GF12476@csclub.uwaterloo.ca>
	 <200809031859.28203.alistair@devzero.co.uk>
	 <20080903201620.GS12474@csclub.uwaterloo.ca>
	 <200809032132.34967.alistair@devzero.co.uk>
	 <20080903203954.GT12474@csclub.uwaterloo.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Currently I've no internet connection, so I'm depend off the hotspot I
can found when I'm close to my windows
Anyway, my connection will be activated soon, so please poke me again monday.
I'ts true that I should take a look at sf.net patchs ...
Anyway, this laptop should work with asus-laptop oO.
modprobe asus-laptop gives you "No such device" ?

On Wed, Sep 3, 2008 at 10:39 PM, Lennart Sorensen
<lsorense@csclub.uwaterloo.ca> wrote:
> On Wed, Sep 03, 2008 at 09:32:34PM +0100, Alistair John Strachan wrote:
>> On Wednesday 03 September 2008 21:16:20 Lennart Sorensen wrote:
>> > On Wed, Sep 03, 2008 at 06:59:28PM +0100, Alistair John Strachan wrote:
>> > > Unless I'm mistaken, the current asus-laptop maintainer is Corentin
>> > > Chary, who I've added to CC on your behalf.
>> >
>> > Excellent.  Now where do I find such info?
>>
>> MAINTAINERS, though admittedly the section is dubiously named. His name's also
>> present in the copyright in the source file (drivers/misc/asus-laptop.c). It's
>> also present in the source code log for this file (git log drivers/misc/asus-
>> laptop.c) if you discount people who have made only janitorial or API changes.
>>
>> Either way, he's CC'ed, and hopefully more responsive than the sourceforge
>> project :-) If not, pester Andrew Morton with the patch (and Andi Kleen, since
>> it's ACPI territory).
>
> OK.  I will go test the patch out and see if it still works.
>
> --
> Len Sorensen
>
