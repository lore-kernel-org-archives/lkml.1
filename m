Return-Path: <linux-kernel-owner+w=401wt.eu-S1752746AbYIJHj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbYIJHj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 03:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbYIJHjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 03:39:22 -0400
Received: from hpsmtp-eml18.kpnxchange.com ([213.75.38.118]:56058 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751179AbYIJHjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 03:39:21 -0400
From: Frans Pop <elendil@planet.nl>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [bisected][resend] pnp: Huge number of "io resource overlap" messages
Date: Wed, 10 Sep 2008 09:39:15 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Rene Herman <rene.herman@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <200809091250.08620.elendil@planet.nl> <200809091826.18876.elendil@planet.nl> <200809091140.25597.bjorn.helgaas@hp.com>
In-Reply-To: <200809091140.25597.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809100939.17045.elendil@planet.nl>
X-OriginalArrivalTime: 10 Sep 2008 07:39:19.0529 (UTC) FILETIME=[55BBE590:01C91318]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008, Bjorn Helgaas wrote:
> If the PCI device isn't fully initialized, it doesn't seem right to
> check it for resource conflicts.  But I don't know how to tell that.
>
> Can you figure out where the 1f.5 and 1f.6 resources get assigned?

If the approach suggested by Rene feasible or would you still like me to 
get this info? In the last case I'll need some pointers where exactly to 
look.

Cheers,
FJP
