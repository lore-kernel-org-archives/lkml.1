Return-Path: <linux-kernel-owner+w=401wt.eu-S965558AbXEVQhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965558AbXEVQhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 12:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757702AbXEVQh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 12:37:27 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:46016 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001AbXEVQh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 12:37:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rmArmDBzsquS7ifQHn1Qvd4FMzyX7GuusgIx0wTPpkRWxPS4N7B6jv1Juf2P4yvtic/viNdOx5YJmXyJTRxkECE2E9t9RS424Wgy0ZZe5by2AyeSlzWEZ1StTj+P4E45lCPvl5LwUuKKwjcDYVSrqQZWW+ab5U0iUPCt0lFVqO0=
Message-ID: <8aa016e10705220937t6cfbacbj4fe8fc97d135924@mail.gmail.com>
Date: Tue, 22 May 2007 22:07:24 +0530
From: "Dhaval Giani" <dhaval.giani@gmail.com>
To: paapaa125@hotmail.com
Subject: Re: Enabling power states for Core 2 Duo
Cc: linux-kernel@vger.kernel.org, hancockr@shaw.ca
In-Reply-To: <292f39920705220935h664175a9wbcf1713f7f912d05@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4652FD77.6090709@shaw.ca>
	 <BAY20-F21042242E1DE82AF8A4EE7F9360@phx.gbl>
	 <292f39920705220935h664175a9wbcf1713f7f912d05@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >>I'm probably missing something crucial here. So how do I enable power
> >>states? I'm using 64-bit Gentoo. My mobo is Asus P5B Deluxe. Otherwise
> >>ACPI works fine.
> >
> >The BIOS has to expose this support in ACPI, if it doesn't (which is often
> >the case on desktop boards) you won't get any C-state support (well, except
> >for C1 which is just the normal halt state).
>
> But unless I'm not mistaken, I don't have even the C1 state available. I
> seem to have only C0 according to "active state". "Active state is the sleep
> state currently used when the system is idle", isn't it? Here is the source:
>
> http://acpi.sourceforge.net/documentation/processor.html
>
> But are you saying that with most desktop mobos one doesn't usually have the
> different power states available at all? So basically the only means to
> conserve power is to scale the frequency?
>

Please update your BIOS and try.

Thanks and regards
Dhaval
