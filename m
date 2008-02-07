Return-Path: <linux-kernel-owner+w=401wt.eu-S1763089AbYBGVXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763089AbYBGVXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763565AbYBGVSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:18:13 -0500
Received: from gate.crashing.org ([63.228.1.57]:34322 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763556AbYBGVSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:18:09 -0500
Subject: Re: Xilinx: hwicap driver comments
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <47AB6552.7040503@gmail.com>
References: <47AB6552.7040503@gmail.com>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 08:17:46 +1100
Message-Id: <1202419066.7079.130.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-07 at 21:08 +0100, Jiri Slaby wrote:
> - io resources are at least ulong

They should actually be resource_size_t :-)

Ben.


