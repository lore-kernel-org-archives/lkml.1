Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbYJOUXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbYJOUXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 16:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbYJOUXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 16:23:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:37496 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbYJOUXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 16:23:13 -0400
Date: Wed, 15 Oct 2008 16:23:16 -0400
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH] fastboot: Introduce an asynchronous function call
 mechanism
Message-ID: <20081015162316.0a0c284a@infradead.org>
In-Reply-To: <20081015095905.41219c9d.akpm@linux-foundation.org>
References: <20081012194427.2e21c22e@infradead.org>
	<20081015014117.faff3a61.akpm@linux-foundation.org>
	<20081015075246.2e1610f3@infradead.org>
	<20081015095905.41219c9d.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2008 09:59:05 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> > > 
> > > Please talk to Evgeniy about his new thread_pool stuff which I've
> > > suggested become a generic library.
> 
> ^^ this?

if thread pools can deliver me the same ordering guarantees.....
which I kinda doubt given the point of the concept of them..
