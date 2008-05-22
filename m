Return-Path: <linux-kernel-owner+w=401wt.eu-S936062AbYEVWDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936062AbYEVWDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758383AbYEVWD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:03:29 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64533 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761758AbYEVWD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:03:28 -0400
Date: Thu, 22 May 2008 23:02:40 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "Randy.Dunlap" <rdunlap@xenotime.net>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Alexey Starikovskiy <astarikovskiy@suse.de>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] x86: mp_bus_id_to_pci_bus is not needed, 
In-Reply-To: <Pine.LNX.4.64.0805221456090.3694@shark.he.net>
Message-ID: <Pine.LNX.4.55.0805222300480.13339@cliff.in.clinika.pl>
References: <20080519154656.15071.96979.stgit@thinkpad>
 <20080519154709.15071.79793.stgit@thinkpad>
 <alpine.LFD.1.10.0805222348110.3295@apollo.tec.linutronix.de>
 <Pine.LNX.4.64.0805221456090.3694@shark.he.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008, Randy.Dunlap wrote:

> A few correct whitespace fixes shouldn't be a problem, but this one
> isn't even a good change.

 From my experience it varies wildly among maintainers. ;-)

 I would not mind unless it hit clarity of the change itself.

  Maciej
