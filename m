Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbXISXij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbXISXij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 19:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbXISXic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 19:38:32 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41929 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750909AbXISXib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 19:38:31 -0400
Date: Wed, 19 Sep 2007 16:37:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Anton Altaparmakov <aia21@cam.ac.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       marc.smith@esmail.mcc.edu
Subject: Re: VM/VFS bug with large amount of memory and file systems?
Message-Id: <20070919163713.6d0f752c.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0709191628170.3971@schroedinger.engr.sgi.com>
References: <C2A8AED2-363F-4131-863C-918465C1F4E1@cam.ac.uk>
	<1189850897.21778.301.camel@twins>
	<20070915035228.8b8a7d6d.akpm@linux-foundation.org>
	<13126578-A4F8-43EA-9B0D-A3BCBFB41FEC@cam.ac.uk>
	<20070917163257.331c7605@twins>
	<46EEB532.3060804@redhat.com>
	<20070917131526.e8db80fe.akpm@linux-foundation.org>
	<46EEE7B7.1070206@redhat.com>
	<20070917141127.ab2ae148.akpm@linux-foundation.org>
	<46F19ED6.20501@redhat.com>
	<20070919154542.4ed8ea1e.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0709191628170.3971@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 16:29:02 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Wed, 19 Sep 2007, Andrew Morton wrote:
> 
> > Cool.
> 
> Should I rediff on top of rc6-mm1 for submission? When will you be able to 
> take it?
>  

erm, I spose we should be concentrating on stabilising the current pile of
crud for 2.6.24 - it sure needs it.

Sometime around 2.6.24-rc1 would suit.

