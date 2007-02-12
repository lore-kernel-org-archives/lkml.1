Return-Path: <linux-kernel-owner+w=401wt.eu-S1030217AbXBLWir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030217AbXBLWir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 17:38:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030216AbXBLWir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 17:38:47 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45992 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030217AbXBLWiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 17:38:46 -0500
From: Andi Kleen <andi@firstfloor.org>
To: "Giuliano Procida" <giuliano.procida@googlemail.com>
Subject: Re: [PATCH x86 for review II] [26/39] i386: fix 32-bit ioctls on x64_32
Date: Mon, 12 Feb 2007 23:28:43 +0100
User-Agent: KMail/1.9.5
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
References: <20070212837.963446000@suse.de> <20070212073814.1879213DA0@wotan.suse.de> <5c8016cf0702120524p4bac240du6dc778745f537c9d@mail.gmail.com>
In-Reply-To: <5c8016cf0702120524p4bac240du6dc778745f537c9d@mail.gmail.com>
Organization: -
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702122328.43744.andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 February 2007 14:24, Giuliano Procida wrote:
> This is a nicer version of the MTRR compatibilty ioctl patch, compiles
> smaller and also tested.

Perhaps nice, but doesn't apply. I will stay with the old version for now

Applying patch patches/fix-32-bit-ioctls-on-x64_32
patching file arch/i386/kernel/cpu/mtrr/if.c
Hunk #1 FAILED at 154.
1 out of 1 hunk FAILED -- rejects in file arch/i386/kernel/cpu/mtrr/if.c


-Andi
