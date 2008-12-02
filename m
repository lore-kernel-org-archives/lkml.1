Return-Path: <linux-kernel-owner+w=401wt.eu-S1755377AbYLBPzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbYLBPzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 10:55:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYLBPy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 10:54:57 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:4275 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbYLBPy5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 10:54:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=Qv9AwluzOu68PxxTgIPs4ipphU4fnDDFknLFJ0NHCBo+BzVxIvHjrJPq3spYeegKQb
         ifF80HAjpfE/0qGLEvWxhHNOy8b3rKsXZvkU8j02JrpbDM9j+bWl7XptbN9NMtP6kzz9
         kE2wB3uF5cdpooIh5mSIUrqN2bIcxztfe4BoE=
Date: Tue, 2 Dec 2008 16:54:52 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Alistair John Strachan <alistair@devzero.co.uk>
Cc: pazke <pazke@ports.donpac.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28-rc7
Message-ID: <20081202165452.3dec53b8@varda>
In-Reply-To: <200812021520.25856.alistair@devzero.co.uk>
References: <alpine.LFD.2.00.0812012004370.3256@nehalem.linux-foundation.org>
	<20081202131158.GA15186@ports.donpac.ru>
	<20081202154815.48379b99@varda>
	<200812021520.25856.alistair@devzero.co.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, 2 Dec 2008 15:20:25 +0000
Alistair John Strachan <alistair@devzero.co.uk> escribió:

> Could you please find out what framebuffer driver your distro is loading 
> (probably nvidiafb, I'd guess) before starting X, and what Xorg driver Ubuntu 
> use in this "safe graphics mode" (nv, vesa)?

 Forgot about it in the other replay it is vesa iirc 

> Also, could you try removing the 
> nvidia module in the older kernel and confirm that the same VT corruption does 
> not occur, so Rafael can identify this as a regression?
> 
