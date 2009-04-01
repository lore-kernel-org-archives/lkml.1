Return-Path: <linux-kernel-owner+w=401wt.eu-S1758022AbZDACO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022AbZDACO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 22:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbZDACOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 22:14:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54553 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753339AbZDACOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 22:14:47 -0400
Message-ID: <49D2CD28.9080700@redhat.com>
Date: Tue, 31 Mar 2009 22:10:48 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, frankeh@watson.ibm.com, akpm@osdl.org,
       nickpiggin@yahoo.com.au, hugh@veritas.com
Subject: Re: [patch 2/6] Guest page hinting: volatile swap cache.
References: <20090327150905.819861420@de.ibm.com> <20090327151011.798602788@de.ibm.com>
In-Reply-To: <20090327151011.798602788@de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Schwidefsky wrote:
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> From: Hubertus Franke <frankeh@watson.ibm.com>
> From: Himanshu Raj
> 
> The volatile page state can be used for anonymous pages as well, if
> they have been added to the swap cache and the swap write is finished.

> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
