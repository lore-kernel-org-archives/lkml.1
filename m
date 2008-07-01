Return-Path: <linux-kernel-owner+w=401wt.eu-S1761160AbYGAW0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761160AbYGAW0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 18:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbYGAW0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 18:26:37 -0400
Received: from xenotime.net ([66.160.160.81]:51538 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757196AbYGAW0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 18:26:36 -0400
Date: Tue, 1 Jul 2008 15:26:24 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: RFC: Add mtdset= to Documentation/kernel-parameters
In-Reply-To: <20080701221732.GA16816@flint.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0807011524520.26330@shark.he.net>
References: <20080701215726.GA22880@fluff.org.uk> <20080701221732.GA16816@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2008, Russell King - ARM Linux wrote:

> On Tue, Jul 01, 2008 at 10:57:26PM +0100, Ben Dooks wrote:
> > Does anyone have any comments about adding this patch
> > to describe the ARM/S3C2412 Jive machine specific kernel
> > commandline parameter mtdset?
> 
> Only that it should be part of the patch which adds the mtdset=
> parameter rather than a separate stand alone patch.

Not caused by this patch, but Documentation/kernel-parameters.txt
needs a "ARM" entry/description near the top of the file in the
section that begins with:

"""The parameters listed below are only valid if certain kernel build options were
enabled and if respective hardware is present. The text in square brackets at
the beginning of each description states the restrictions within which a
parameter is applicable:"""

-- 
~Randy
