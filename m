Return-Path: <linux-kernel-owner+w=401wt.eu-S1758512AbYBWMDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758512AbYBWMDB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 07:03:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbYBWMCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 07:02:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbYBWMCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 07:02:52 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <12037544671847-git-send-email-xiyou.wangcong@gmail.com>
References: <12037544671847-git-send-email-xiyou.wangcong@gmail.com> <12037544592096-git-send-email-xiyou.wangcong@gmail.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>, Bryan Wu <bryan.wu@analog.com>
Subject: Re: [PATCH 01/16] Make the macro get_personality function-like.
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Sat, 23 Feb 2008 12:02:41 +0000
Message-ID: <567.1203768161@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


WANG Cong <xiyou.wangcong@gmail.com> wrote:

> This patch makes the macro get_personality function-like.
> 
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Acked-By: David Howells <dhowells@redhat.com>
