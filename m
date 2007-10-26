Return-Path: <linux-kernel-owner+w=401wt.eu-S1765511AbXJZVXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765511AbXJZVXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 17:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754932AbXJZVXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 17:23:10 -0400
Received: from smtp-out.google.com ([216.239.45.13]:18743 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbXJZVXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 17:23:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=EvqmSugVITmHt9oV3JwMJhLIh5zz12DJOw8PRyiWIYae+FIyDgvD4R4QQ1kAKbocc
	JChyD8oI39zlIKx603paw==
Date: Fri, 26 Oct 2007 14:22:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Matt Mackall <mpm@selenic.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dave Hansen <haveblue@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: [PATCH 2/12] maps4: From: Dave Hansen <haveblue@us.ibm.com>
In-Reply-To: <3.430487409@selenic.com>
Message-ID: <alpine.DEB.0.9999.0710261422160.13709@chino.kir.corp.google.com>
References: <3.430487409@selenic.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007, Matt Mackall wrote:

> The following replaces the earlier patches sent.  It should address
> David Rientjes's comments, and has been compile tested on all the
> architectures that it touches, save for parisc.
> 

Looks good, thanks.
