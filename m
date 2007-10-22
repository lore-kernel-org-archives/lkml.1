Return-Path: <linux-kernel-owner+w=401wt.eu-S1752901AbXJVXL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbXJVXL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 19:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbXJVXLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 19:11:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:42858 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbXJVXLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 19:11:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dLxHGEkuks0XoyqJKn5fVZJDbo15Wih6iwYzuDBxQkzTBhCyqbUwdB1Hf+PeBiur92tDQwKt+dM0yrFWadU8ovEC5BXSIJcH3HH5TsPxIonEfH+JWSLpGuKmNoLbLaUX4QOUNCsTC+0Oi5+A4hqajiB3kX4WsPEORNQAC8wa4so=
Message-ID: <b6a2187b0710221611j41a25697q2e4b867646a9214c@mail.gmail.com>
Date: Tue, 23 Oct 2007 07:11:49 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Frans Pop" <elendil@planet.nl>
Subject: Re: latest 2.6.23 git missing ACPI POWER_SUPPLY
Cc: "Alexey Starikovskiy" <aystarik@gmail.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200710221633.42619.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6a2187b0710220045q2920c0dat9ebe4850b02d1bbf@mail.gmail.com>
	 <E1IjvB3-0005oG-N9@faramir.fjphome.nl> <471CA0AA.4000904@gmail.com>
	 <200710221633.42619.elendil@planet.nl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/07, Frans Pop <elendil@planet.nl> wrote:
> On Monday 22 October 2007, Alexey Starikovskiy wrote:
> > Frans Pop wrote:
> > > I must say that having these relatively top-level ACPI settings
> > > depending on something that is relatively buried away is not very
> > > intuitive!

That's really something that's hard to imagine having another
dependency somewhere else. Got it now.

Thanks for your help.

Jeff.
