Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbYHJLBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbYHJLBl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 07:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbYHJLBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 07:01:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782AbYHJLBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 07:01:33 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1218322619.24441.6.camel@brick>
References: <1218322619.24441.6.camel@brick>
To: Harvey Harrison <harvey.harrison@gmail.com>, jmorris@namei.org
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cred: add static, remove extern on function definitions
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Sun, 10 Aug 2008 12:01:04 +0100
Message-ID: <12546.1218366064@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison <harvey.harrison@gmail.com> wrote:

> kernel/cred.c:460:13: warning: function 'revert_creds' with external linkage has definition
> kernel/cred.c:72:6: warning: symbol 'put_tgcred' was not declared. Should it be static?
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Acked-by: David Howells <dhowells@redhat.com>
