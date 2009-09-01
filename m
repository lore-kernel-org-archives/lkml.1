Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbZIALVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbZIALVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 07:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbZIALVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 07:21:41 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55678 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbZIALVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 07:21:39 -0400
Date: Tue, 1 Sep 2009 12:21:30 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: Add common files of platform definition and
	cpu implementing
Message-ID: <20090901112130.GB19719@n2100.arm.linux.org.uk>
References: <4A8A8ABB.6050201@gmail.com> <e68bb3470908180412t253cf826ifa0e399dc7358bc4@mail.gmail.com> <e68bb3470908192033n104ed426kbf2b28efbd179348@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e68bb3470908192033n104ed426kbf2b28efbd179348@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 11:33:32AM +0800, Wan ZongShun wrote:
> How about this fixed patches?
> Could I merge renaming 'ts' and 'keypad' platform_driver name into this patch?
> and in case the drivers miss binding to platform device when via input
> subsystem.

I think it would make sense for this patch to also include _just_ the
change to the driver name for those drivers.  If you could submit that
to the patch system, I'll apply it later today.

Thanks.
