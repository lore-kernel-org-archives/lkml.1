Return-Path: <linux-kernel-owner+w=401wt.eu-S1946701AbXD3TPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946701AbXD3TPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 15:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946675AbXD3TPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 15:15:37 -0400
Received: from mga07.intel.com ([143.182.124.22]:45389 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946703AbXD3TPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 15:15:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,471,1170662400"; 
   d="scan'208";a="221822753"
Message-ID: <46364017.2040009@linux.intel.com>
Date: Mon, 30 Apr 2007 12:14:31 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: Please revert [PATCH] user of the jiffies rounding patch: Slab
References: <Pine.LNX.4.64.0704281403140.12122@schroedinger.engr.sgi.com>  <4633D1A2.6010002@linux.intel.com>  <Pine.LNX.4.64.0704281632001.12695@schroedinger.engr.sgi.com> <1177803630.3477.3.camel@laptopd505.fenrus.org> <Pine.LNX.4.64.0704301042580.6343@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0704301042580.6343@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Umm you did not read the last bit of the description? It talks about 
> firing all timers on all cpus at once.
>  

it talks about AVOIDING firing all timers on all cpus at once.
