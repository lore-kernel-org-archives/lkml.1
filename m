Return-Path: <linux-kernel-owner+w=401wt.eu-S1759088AbYDYHOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759088AbYDYHOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 03:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbYDYHOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 03:14:00 -0400
Received: from keg.few.vu.nl ([130.37.24.4]:55476 "EHLO keg.few.vu.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbYDYHOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 03:14:00 -0400
Date: Fri, 25 Apr 2008 09:13:32 +0200 (CEST)
From: Erik Bosman <ejbosman@cs.vu.nl>
X-X-Sender: ebn310@keg.few.vu.nl
To: Adrian Bunk <bunk@kernel.org>
cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] x86: make enable_TSC() static
In-Reply-To: <20080423095251.GP28933@cs181133002.pp.htv.fi>
Message-ID: <Pine.GSO.4.56.0804250912250.3088@keg.few.vu.nl>
References: <20080423095251.GP28933@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 Apr 2008, Adrian Bunk wrote:

> This patch makes the needlessly global enable_TSC() static.
>

Ah indeed, I added it for symmetry. But I guess there are more
important considerations.

Erik
