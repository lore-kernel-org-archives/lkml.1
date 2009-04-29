Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653AbZD2Jr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbZD2Jr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbZD2JrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:47:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35497 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807AbZD2JrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:47:19 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090428223050.GA12020@redhat.com>
References: <20090428223050.GA12020@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: s/parent/real_parent/ in binfmt_elf_fdpic.c
Date: Wed, 29 Apr 2009 10:46:27 +0100
Message-ID: <7132.1240998387@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> ->real_parent is the parent. ->parent may be the tracer.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: David Howells <dhowells@redhat.com>
