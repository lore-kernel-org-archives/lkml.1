Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbZIUIhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbZIUIhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 04:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754929AbZIUIhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 04:37:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38286 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798AbZIUIhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 04:37:37 -0400
Date: Mon, 21 Sep 2009 09:37:25 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Bityutskiy Artem <Artem.Bityutskiy@nokia.com>,
       Siarhei Siamashka <siarhei.siamashka@nokia.com>
Subject: Re: [PATCH v3 1/2] ARM: Introduce ARM_L1_CACHE_SHIFT to define
	cache line size
Message-ID: <20090921083724.GA27357@n2100.arm.linux.org.uk>
References: <188e5f14411c04ec999ef25bfe3616f77f1387b0.1252788311.git.kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <188e5f14411c04ec999ef25bfe3616f77f1387b0.1252788311.git.kirill@shutemov.name>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 12, 2009 at 11:48:30PM +0300, Kirill A. Shutemov wrote:
> Currently kernel believes that all ARM CPUs have L1_CACHE_SHIFT == 5.
> It's not true at least for CPUs based on Cortex-A8.

Please send this to the patch system.  There's no need to add the "V2"
comments to it when you do.
