Return-Path: <linux-kernel-owner+w=401wt.eu-S1761779AbZDAIOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761779AbZDAIOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 04:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761538AbZDAINl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 04:13:41 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:51156 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761506AbZDAINj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 04:13:39 -0400
Date: Wed, 1 Apr 2009 10:13:34 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, frankeh@watson.ibm.com, akpm@osdl.org,
       nickpiggin@yahoo.com.au, hugh@veritas.com
Subject: Re: [patch 2/6] Guest page hinting: volatile swap cache.
Message-ID: <20090401101334.7e6ea848@skybase>
In-Reply-To: <49D2CD28.9080700@redhat.com>
References: <20090327150905.819861420@de.ibm.com>
	<20090327151011.798602788@de.ibm.com>
	<49D2CD28.9080700@redhat.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 22:10:48 -0400
Rik van Riel <riel@redhat.com> wrote:

> Martin Schwidefsky wrote:
> > From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > From: Hubertus Franke <frankeh@watson.ibm.com>
> > From: Himanshu Raj
> > 
> > The volatile page state can be used for anonymous pages as well, if
> > they have been added to the swap cache and the swap write is finished.
> 
> > Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Acked-by: Rik van Riel <riel@redhat.com>

Thanks you for the review. I'll add the Acked-by.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

