Return-Path: <linux-kernel-owner+w=401wt.eu-S1758802AbZFJRlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802AbZFJRlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 13:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbZFJRk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 13:40:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437AbZFJRk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 13:40:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Q: PTRACE_ATTACH && -EINTR
In-Reply-To: Oleg Nesterov's message of  Wednesday, 10 June 2009 15:11:16 +0200 <20090610131116.GA10406@redhat.com>
References: <20090608161204.GA3986@redhat.com>
	<20090608173944.B57EBFC3C6@magilla.sf.frob.com>
	<20090608183627.GA14734@redhat.com>
	<20090609014449.8BE46FC3C6@magilla.sf.frob.com>
	<20090610131116.GA10406@redhat.com>
X-Zippy-Says: I'm changing the CHANNEL..  But all I get is commercials for
    ``RONCO MIRACLE BAMBOO STEAMERS''!
Message-Id: <20090610174058.6F48CFC3D3@magilla.sf.frob.com>
Date: Wed, 10 Jun 2009 10:40:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'll wait until rename or -mm bits will be applied, then send this patch.

Or you could send it to stable@ for 2.6.29/2.6.30 and let akpm figure out
the order for merging with the rest.

> Fortunately the problem is not serious, ->cred_exec_mutex should be mostly
> free.

Agreed.


Thanks,
Roland
