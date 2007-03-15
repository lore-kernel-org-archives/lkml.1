Return-Path: <linux-kernel-owner+w=401wt.eu-S932980AbXCOTb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980AbXCOTb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933159AbXCOTb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:31:56 -0400
Received: from smtp.osdl.org ([65.172.181.24]:37738 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932980AbXCOTbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:31:55 -0400
Date: Thu, 15 Mar 2007 11:31:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Pierre.Peiffer@bull.net, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jean-pierre.dion@bull.net
Subject: Re: [PATCH 2.6.21-rc3-mm2 4/4] sys_futex64 : allows 64bit futexes
Message-Id: <20070315113136.b04ce342.akpm@linux-foundation.org>
In-Reply-To: <45F99A8B.4050003@redhat.com>
References: <20070313095203.154246923@bull.net>
	<20070313095549.813330645@bull.net>
	<20070315110752.f1df4509.akpm@linux-foundation.org>
	<45F99A8B.4050003@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007 12:12:11 -0700 Ulrich Drepper <drepper@redhat.com> wrote:

> Andrew Morton wrote:
> > Why do we want 64-bit futexes?
> 
> I sent this to you already on 1/12/2007:
> 
> http://udrepper.livejournal.com/13123.html
> 

Well OK.  But that doesn't actually explain why 64-bit mutexes are needed.
It just says they are required.
