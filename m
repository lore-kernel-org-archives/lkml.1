Return-Path: <linux-kernel-owner+w=401wt.eu-S1161535AbXDXDJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161535AbXDXDJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 23:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161548AbXDXDJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 23:09:29 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161546AbXDXDJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 23:09:28 -0400
Date: Mon, 23 Apr 2007 20:08:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, shak <dshaks@redhat.com>,
       jakub@redhat.com, drepper@redhat.com
Subject: Re: [PATCH] lazy freeing of memory through MADV_FREE
Message-Id: <20070423200859.e2e9ab3d.akpm@linux-foundation.org>
In-Reply-To: <462D713D.6050401@redhat.com>
References: <46247427.6000902@redhat.com>
	<20070420135715.f6e8e091.akpm@linux-foundation.org>
	<462932BE.4020005@redhat.com>
	<20070420150618.179d31a4.akpm@linux-foundation.org>
	<4629524C.5040302@redhat.com>
	<462ACA40.8070407@yahoo.com.au>
	<462B0156.9020407@redhat.com>
	<462BFAF3.4040509@yahoo.com.au>
	<462C2DC7.5070709@redhat.com>
	<462C2F33.8090508@redhat.com>
	<462C7A6F.9030905@redhat.com>
	<462C88B1.8080906@yahoo.com.au>
	<462C8B0A.8060801@redhat.com>
	<462C8BFF.2050405@yahoo.com.au>
	<462D713D.6050401@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007 22:53:49 -0400 Rik van Riel <riel@redhat.com> wrote:

> I don't see why we need the attached, but in case you find
> a good reason, here's my signed-off-by line for Andrew :)

Andew is in a defensive crouch trying to work his way through all the bugs
he's been sent.  After I've managed to release 2.6.21-rc7-mm1 (say, December)
I expect I'll drop the MADV_FREE stuff, give you a run at creating a new
patch series.
