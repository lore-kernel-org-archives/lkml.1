Return-Path: <linux-kernel-owner+w=401wt.eu-S1751125AbXEXQh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125AbXEXQh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 12:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750721AbXEXQhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 12:37:17 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59895 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750710AbXEXQhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 12:37:15 -0400
Date: Thu, 24 May 2007 09:37:14 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: young dave <hidave.darkstar@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc2-mm1 SLUB oops
In-Reply-To: <a8e1da0705240111l790ee29emdd872cf6c56a5e37@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705240936360.27844@schroedinger.engr.sgi.com>
References: <a8e1da0705240111l790ee29emdd872cf6c56a5e37@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007, young dave wrote:

> When I exec aumix from console, the kernel oops seems in modprobe
> process, and after a while , system hanged.

Reboot with slub_debug as a kernel parameter please.
