Return-Path: <linux-kernel-owner+w=401wt.eu-S1752763AbZFYOcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbZFYOcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 10:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbZFYOb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 10:31:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52368 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751009AbZFYOb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 10:31:56 -0400
Date: Thu, 25 Jun 2009 15:33:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>, Brian Swetland <swetland@google.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] [ARM] msm: add minimal board file for HTC Dream
 device
Message-ID: <20090625153304.7b27fe34@lxorguk.ukuu.org.uk>
In-Reply-To: <20090625135532.GB11875@n2100.arm.linux.org.uk>
References: <1245033557-10968-1-git-send-email-swetland@google.com>
	<1245033557-10968-2-git-send-email-swetland@google.com>
	<1245033557-10968-3-git-send-email-swetland@google.com>
	<1245033557-10968-4-git-send-email-swetland@google.com>
	<20090615132248.GB14555@elf.ucw.cz>
	<a55d774e0906151125h36ee7c36yb9ecf5fb3fb8e41b@mail.gmail.com>
	<20090615182850.GA10490@elf.ucw.cz>
	<a55d774e0906151151p223895b1pc01be38e1d0e9358@mail.gmail.com>
	<20090624205618.GD9149@elf.ucw.cz>
	<20090625135532.GB11875@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I thought Alan's preference was for me to be out of the loop on machine
> specific stuff, and for platform maintainers to push their stuff directly
> into linux-next and to Linus.

msm_serial is already in the Linus tree, in fact it just scraped the
cutoff.

