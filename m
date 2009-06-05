Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbZFESFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbZFESFS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 14:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbZFESFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 14:05:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53257 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751233AbZFESFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 14:05:06 -0400
Date: Fri, 5 Jun 2009 19:06:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: lkml@morethan.org
Cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org
Subject: Re: [Compile Warning] 2.6.30-rc8 build
Message-ID: <20090605190616.422cda4f@lxorguk.ukuu.org.uk>
In-Reply-To: <200906051240.52615.lkml@morethan.org>
References: <200906051143.06119.lkml@morethan.org>
	<ada63fawq7y.fsf@cisco.com>
	<200906051240.52615.lkml@morethan.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Of course, I, just like gcc, did not know the machine had already died.
> I'll stick an "i = something" at the top (NULL?) just to shut up gcc.

And it will not get merged. Current gcc understands the code perfectly
well.

