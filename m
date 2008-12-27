Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbYL0Atz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbYL0Atz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 19:49:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbYL0Atq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 19:49:46 -0500
Received: from infernal.debian.net ([87.230.26.131]:54658 "EHLO
	infernal.debian.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbYL0Atq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 19:49:46 -0500
Date: Sat, 27 Dec 2008 01:49:28 +0100
From: Andreas Bombe <andreas.bombe@mytum.de>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Joerg Roedel <joro@8bytes.org>,
       Edward Estabrook <edward.estabrook.lkml@gmail.com>,
       linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, gregkh@suse.de,
       edward.estabrook@gmail.com, edward_estabrook@agilent.com
Subject: Re: [PATCH 1/1] Userspace I/O (UIO): Add support for userspace DMA
	(corrected)
Message-ID: <20081227004928.GA28225@case.infernal>
References: <208aa0f00812031751n27a75d21h8747054651639463@mail.gmail.com> <20081211003340.GB3078@local> <20081225123004.GA13640@8bytes.org> <20081225152014.GA3079@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081225152014.GA3079@local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2008 at 04:20:15PM +0100, Hans J. Koch wrote:
> On Thu, Dec 25, 2008 at 01:30:04PM +0100, Joerg Roedel wrote:
> > I like that idea of a seperate directory in sysfs. How about allocating
> > DMA memory by creating files in this directory.
> 
> Nice idea, but AFAICT sysfs doesn't support creating files from userspace.

For that there is configfs.
