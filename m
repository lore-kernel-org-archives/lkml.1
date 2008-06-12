Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602AbYFLIOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbYFLIOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 04:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYFLINy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 04:13:54 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:54504 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbYFLINw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 04:13:52 -0400
Message-ID: <4850DABE.3050900@aitel.hist.no>
Date: Thu, 12 Jun 2008 10:13:50 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080420)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       linux-mm@kvack.org, Rik van Riel <riel@redhat.com>
Subject: Re: 2.6.26-rc5-mm2  compile error in vmscan.c
References: <20080609223145.5c9a2878.akpm@linux-foundation.org>	<484E6A68.4060203@aitel.hist.no> <20080610113733.8d924c0e.akpm@linux-foundation.org>
In-Reply-To: <20080610113733.8d924c0e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Thanks.  I guess this will get you going.
>   
Thanks, that did the trick. It compiled fine this time.

Helge Hafting
