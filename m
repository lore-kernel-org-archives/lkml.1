Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbYKNSEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbYKNSEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 13:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbYKNSER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 13:04:17 -0500
Received: from gw.goop.org ([64.81.55.164]:59863 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbYKNSER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 13:04:17 -0500
Message-ID: <491DBD9E.6030703@goop.org>
Date: Fri, 14 Nov 2008 10:04:14 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH 1/2] mm: implement remap_pfn_range with apply_to_page_range
References: <491C61B1.10005@goop.org> <200811141417.35724.nickpiggin@yahoo.com.au> <491D0B2F.7050900@goop.org> <200811141835.17073.nickpiggin@yahoo.com.au>
In-Reply-To: <200811141835.17073.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> No, adding a cycle here or an indirect function call there IMO is
> not acceptable in core mm/ code without a good reason.
>   

<shrug> OK.

    J
