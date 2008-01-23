Return-Path: <linux-kernel-owner+w=401wt.eu-S1755452AbYAWRNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbYAWRNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 12:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbYAWRNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 12:13:00 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:53722 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337AbYAWRM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 12:12:59 -0500
Date: Wed, 23 Jan 2008 18:12:52 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Jochen Friedrich <jochen@scram.de>,
       Vitaly Bordug <vitb@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCHv2 0/8] [POWERPC] 8xx cleanups
Message-ID: <20080123171252.GA22967@uranus.ravnborg.org>
References: <4797641F.4000902@scram.de> <CA8FFE19-B84A-426B-9B1C-EF0F7C87AE47@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA8FFE19-B84A-426B-9B1C-EF0F7C87AE47@kernel.crashing.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> What impact do the have on boards in arch/ppc being able to build?

Byt the way what are the plans for powerpc?
We have:
arch/ppc
arch/ppc64
arch/powerpc

It was my understanding that arch/powerpc was supposed
to be the future unified powerpc architecture but it
does not even provide a defconfig.

And I do not see too much happening to do so - but that maybe
because I looked at a wrong place.

	Sam
