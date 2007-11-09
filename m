Return-Path: <linux-kernel-owner+w=401wt.eu-S1762992AbXKIPPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762992AbXKIPPR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 10:15:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760358AbXKIPPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 10:15:06 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35344 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760068AbXKIPPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 10:15:05 -0500
Date: Fri, 9 Nov 2007 07:15:03 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2 slab vs slob tbench numbers
In-Reply-To: <200711092336.56172.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0711090712440.13823@schroedinger.engr.sgi.com>
References: <200711092336.56172.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Nov 2007, Nick Piggin wrote:

> Just ran some tbench numbers (from dbench-3.04), on a 2 socket, 8
> core x86 system, with 1 NUMA node per socket. With kernel 2.6.24-rc2,
> comparing slab vs slub allocators.

You saw the discussion at 
http://marc.info/?l=linux-kernel&m=119354245426072&w=2
and the patches / configurations that were posted to address the issues?

Could you try these?
