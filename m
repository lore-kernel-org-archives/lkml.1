Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680AbYLEMCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbYLEMCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 07:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbYLEMCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 07:02:25 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49164 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbYLEMCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 07:02:24 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200812051858.00246.rusty@rustcorp.com.au>
References: <200812051858.00246.rusty@rustcorp.com.au> <20081203163207.13965.56517.stgit@warthog.procyon.org.uk> <20081203163212.13965.80352.stgit@warthog.procyon.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] [PATCH] param: Stop gcc from inlining empty weak functions
Date: Fri, 05 Dec 2008 12:02:20 +0000
Message-ID: <8631.1228478540@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> wrote:

> commit 4858874241391aa62b5818781f702883e4ddf4ed
> Author: Rusty Russell <rusty@rustcorp.com.au>
> Date:   Fri Dec 5 18:56:34 2008 +1030
> 
>     Move arch_get_boot_command_line out of init/main.c for broken gccs.

Acked-by: David Howells <dhowells@redhat.com>
