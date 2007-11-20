Return-Path: <linux-kernel-owner+w=401wt.eu-S1764569AbXKTWEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764569AbXKTWEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 17:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756766AbXKTWE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 17:04:29 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:32273 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780AbXKTWE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 17:04:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:newsgroups:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=coIShqMXjx8uV7RMwoqGMzZaqD90bbXr8xl16+egMvMOtLcXms7zZAF69OjmuFO3z22Ilm+hMoDNIYbeRILP/zjkyi38GFOoFBUg9XBqRhxHRu/z0lWWpNX7r4YzNdjsuIkM4m1Gmf5DHm48X08Gk/UtexSA3jNP5xEydFj1a78=
Message-ID: <474359E3.2020603@gmail.com>
Date: Wed, 21 Nov 2007 01:04:19 +0300
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
User-Agent: IceDove 1.5.0.14pre (X11/20071020)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.ports.arm.kernel
To: ian <spyro@f2s.com>
CC: ARM Linux <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] 0/4 Support for Toshiba TMIO multifunction devices
References: <1195591234.2329.52.camel@wirenth>
In-Reply-To: <1195591234.2329.52.camel@wirenth>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

ian wrote:
> Hi guys.
> 
> This patchset contains support for three toshiba multifunction devices.

Just to note, that there is an alternative implementation for at least 
the tc6393 chip devices. Most current version of those patches can be 
found in the OpenEmbedded monotone.


> 
> it introduces a small but useful bit of code as a library for similar
> devices, and includes support for these chips on the toshiba e-series
> family of handhelds.
> 
> please copy me on reply!
> 

-- 
With best wishes
Dmitry
