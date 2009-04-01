Return-Path: <linux-kernel-owner+w=401wt.eu-S1761948AbZDAIOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761948AbZDAIOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 04:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761356AbZDAIOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 04:14:05 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:61151 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761518AbZDAIOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 04:14:02 -0400
Date: Wed, 1 Apr 2009 10:13:57 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, frankeh@watson.ibm.com, akpm@osdl.org,
       nickpiggin@yahoo.com.au, hugh@veritas.com
Subject: Re: [patch 3/6] Guest page hinting: mlocked pages.
Message-ID: <20090401101357.7f714f7a@skybase>
In-Reply-To: <49D2D6D4.8000309@redhat.com>
References: <20090327150905.819861420@de.ibm.com>
	<20090327151012.095486071@de.ibm.com>
	<49D2D6D4.8000309@redhat.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 22:52:04 -0400
Rik van Riel <riel@redhat.com> wrote:

> Martin Schwidefsky wrote:
> > From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > From: Hubertus Franke <frankeh@watson.ibm.com>
> > From: Himanshu Raj
> > 
> > Add code to get mlock() working with guest page hinting. The problem
> > with mlock is that locked pages may not be removed from page cache.
> > That means they need to be stable. 
> 
> > Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Acked-by: Rik van Riel <riel@redhat.com>

I'll add this one as well. Thanks again.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

