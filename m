Return-Path: <linux-kernel-owner+w=401wt.eu-S937439AbXG0RMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937439AbXG0RMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 13:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758860AbXG0RMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 13:12:41 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:45903 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756486AbXG0RMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 13:12:40 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Simon Arlott <simon@fire.lp0.eu>
Subject: Re: Fwd: PNP: Lindent all source files
Date: Fri, 27 Jul 2007 10:57:10 -0600
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <46A928D2.6030702@simon.arlott.org.uk>
In-Reply-To: <46A928D2.6030702@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707271057.10419.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 July 2007 05:05:54 pm Simon Arlott wrote:
> Does anyone ever review what Lindent does? There's a fix up patch after this 
> but it missed this at the very top of the patch and the labels.

I think you answered your own question.

Did I miss some things in the fixup patch?  Yes; unfortunately,
I'm not as consistent as the machine.

I started another fixup patch with the things you mentioned.
Let me know if you find others, and I'll fix them, too.  I'll
probably wait for the next cycle to do more fixups.

Bjorn

