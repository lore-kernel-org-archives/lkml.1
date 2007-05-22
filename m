Return-Path: <linux-kernel-owner+w=401wt.eu-S1764443AbXEVINJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764443AbXEVINJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 04:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762867AbXEVIH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 04:07:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:51606 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761325AbXEVIHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 04:07:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XWVAfYbObNb/lPjNttEpoEsfigzLMx+QrxHCCImlb3ApR+l2ILWfR1NXraiS/Tn6hfBATtVYe0EEl8SJnQBecl+3gZ0ihmvllsOBWry+INa2MW8jYjLWtg82s/F1GihEXCupPa0Bv2ZPI/Cf9Fd6ZThz61Qzgc65lmxu072QwQQ=
Message-ID: <21d7e9970705220107mc096135nc26af32830d83646@mail.gmail.com>
Date: Tue, 22 May 2007 18:07:52 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Cc: "Jon Smirl" <jonsmirl@gmail.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <4652295E.7060305@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705171423.46748.jesse.barnes@intel.com>
	 <9e4733910705210901v5996cacas640f211404c519c6@mail.gmail.com>
	 <200705210914.22663.jbarnes@virtuousgeek.org>
	 <200705210934.58559.jbarnes@virtuousgeek.org>
	 <9e4733910705211005k761c976o1a6b270d87b49589@mail.gmail.com>
	 <21d7e9970705211014j6eb59326u85f7347a3000f3d3@mail.gmail.com>
	 <4652295E.7060305@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It is a quite sensible idea.
>
> The userspace X server SHOULD be running under a non-root user, with
> appropriate fine-grained privs granted to it.
>
> "I need root to do graphics" is a myopic, antiquated view of the world.

Did I say the X server? There are policy decisions that are root only
also authorisation of processes to render etc..

I'm not sure we can punt all that in-kernel.

Dave.

> 	Jeff
>
>
>
