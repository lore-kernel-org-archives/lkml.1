Return-Path: <linux-kernel-owner+w=401wt.eu-S1751139AbZIUPiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751139AbZIUPiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 11:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750922AbZIUPiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 11:38:10 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47261 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbZIUPiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 11:38:10 -0400
Date: Mon, 21 Sep 2009 16:38:01 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Bityutskiy Artem <Artem.Bityutskiy@nokia.com>,
       Siarhei Siamashka <siarhei.siamashka@nokia.com>
Subject: Re: [PATCH v3 1/2] ARM: Introduce ARM_L1_CACHE_SHIFT to define
	cache line size
Message-ID: <20090921153801.GD30821@n2100.arm.linux.org.uk>
References: <188e5f14411c04ec999ef25bfe3616f77f1387b0.1252788311.git.kirill@shutemov.name> <20090921083724.GA27357@n2100.arm.linux.org.uk> <cc557aab0909210419x795d407erfc07ad0f4550ed88@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cc557aab0909210419x795d407erfc07ad0f4550ed88@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 02:19:57PM +0300, Kirill A. Shutemov wrote:
> On Mon, Sep 21, 2009 at 11:37 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Sat, Sep 12, 2009 at 11:48:30PM +0300, Kirill A. Shutemov wrote:
> >> Currently kernel believes that all ARM CPUs have L1_CACHE_SHIFT == 5.
> >> It's not true at least for CPUs based on Cortex-A8.
> >
> > Please send this to the patch system.  There's no need to add the "V2"
> > comments to it when you do.
> >
> 
> #5716, #5717
> 
> BTW, I ,my pathes without change log in your git tree. Commits 910a17e
> and dca230f. What is wrong with it?

No need to resend them - sorry, I'd forgotten I'd merged them.
