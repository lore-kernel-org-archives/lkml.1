Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578AbZDAC4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbZDAC4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 22:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754268AbZDAC4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 22:56:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45709 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122AbZDAC4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 22:56:23 -0400
Message-ID: <49D2D6D4.8000309@redhat.com>
Date: Tue, 31 Mar 2009 22:52:04 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, frankeh@watson.ibm.com, akpm@osdl.org,
       nickpiggin@yahoo.com.au, hugh@veritas.com
Subject: Re: [patch 3/6] Guest page hinting: mlocked pages.
References: <20090327150905.819861420@de.ibm.com> <20090327151012.095486071@de.ibm.com>
In-Reply-To: <20090327151012.095486071@de.ibm.com>
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
> Add code to get mlock() working with guest page hinting. The problem
> with mlock is that locked pages may not be removed from page cache.
> That means they need to be stable. 

> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
