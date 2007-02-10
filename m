Return-Path: <linux-kernel-owner+w=401wt.eu-S932154AbXBJMHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154AbXBJMHW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 07:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933350AbXBJMHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 07:07:22 -0500
Received: from mx1.suse.de ([195.135.220.2]:51521 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106AbXBJMHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 07:07:20 -0500
From: Andi Kleen <ak@suse.de>
To: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 2.6.21 review I] [18/25] x86_64: Fix x86_64 ioremap base_address
Date: Sat, 10 Feb 2007 13:07:15 +0100
User-Agent: KMail/1.9.5
Cc: OGAWA Hirofumi <hogawa@miraclelinux.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
References: <200702101250.142420000@suse.de> <20070210115031.3D4CE13DFB@wotan.suse.de> <45CDB370.2020401@linux.intel.com>
In-Reply-To: <45CDB370.2020401@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702101307.16093.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 February 2007 12:58, Arjan van de Ven wrote:
> Andi Kleen wrote:
> > From: OGAWA Hirofumi <hogawa@miraclelinux.com>
> > 
> > Current mmconfig has some problems of remapped range.
> 
> 
> eh wasn't there a patch that just ignored the MCFG for the broken 
> system instead?

That's done in a followup patch

-Andi
