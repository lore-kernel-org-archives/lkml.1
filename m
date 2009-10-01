Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbZJAQWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbZJAQWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 12:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbZJAQWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 12:22:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715AbZJAQWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 12:22:19 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4AC4D595.2070202@garzik.org>
References: <4AC4D595.2070202@garzik.org> <1254384558-1018-11-git-send-email-tj@kernel.org> <1254384558-1018-1-git-send-email-tj@kernel.org> <10133.1254402320@redhat.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: dhowells@redhat.com, Tejun Heo <tj@kernel.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       arjan@linux.intel.com
Subject: Re: [PATCH 10/19] workqueue: update cwq alignement and make one more flag bit available
Date: Thu, 01 Oct 2009 17:20:54 +0100
Message-ID: <15216.1254414054@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> wrote:

> The quoted code is a standard kernel technique for creating typed constants
> that are visible to the C compiler (rather than CPP) and debugger.
> 
> It is found in a great many Linux kernel drivers at this point, and is
> definitely not abuse, IMO.

Just because it's common practice, and just because you like it, doesn't make
it not abuse.  But that's a side issue, and fairly irrelevant to the actual
implementation.

David
