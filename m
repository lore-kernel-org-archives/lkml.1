Return-Path: <linux-kernel-owner+w=401wt.eu-S1754899AbXEXVZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbXEXVZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbXEXVZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:25:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51755 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbXEXVZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:25:33 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Ioan Ionita" <opslynx@gmail.com>
Subject: Re: x86-64 2.6.22-rc2 random segfaults
Date: Thu, 24 May 2007 23:15:29 +0200
User-Agent: KMail/1.9.6
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <df47b87a0705241142gce9bdbbkaa3b25be21ba04c0@mail.gmail.com>
In-Reply-To: <df47b87a0705241142gce9bdbbkaa3b25be21ba04c0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705242315.29743.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 May 2007 20:42:07 Ioan Ionita wrote:
> Hello,
> 
> Since upgrading from 2.6.21 to 2.6.22-rc2, I started seeing some
> segfaults in dmesg.
> 2.6.22-rc1-git2 even locked up on me at one point.
> 
> I'm using SLUB. I haven't yet found a way to easily reproduce the
> problem.. Once I do, I'll try a git bisect

Hmm, nothing comes to mind. Please bisect.

-Andi
