Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbZK3Ve5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbZK3Ve5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 16:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbZK3Ve4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 16:34:56 -0500
Received: from smtp-out.google.com ([216.239.45.13]:22113 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbZK3Vez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 16:34:55 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ip3QjQMW4iWvRuyqI5h8KvY0zKTJtWfUcn3REzYdYtS0CQGKuRK4xgBNwtAwT0/4j
	RKFNNuVZxiTs07fcWr80A==
Date: Mon, 30 Nov 2009 13:34:54 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] SLAB: Make synthetic benchmark output more readable
In-Reply-To: <1259486553-4037-1-git-send-email-penberg@cs.helsinki.fi>
Message-ID: <alpine.DEB.2.00.0911301333150.30639@chino.kir.corp.google.com>
References: <1259486553-4037-1-git-send-email-penberg@cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Nov 2009, Pekka Enberg wrote:

> This patch makes the synthetic SLAB benchmark output easier to read by hymans
> and easier to post-process with scripts. The output looks as follows:
> 

Pekka, are you looking to push slab_test.c through your tree?  If so, it 
might make it easier to get the other tests (vmstat_test and 
pagealloc_test) added through Andrew.
