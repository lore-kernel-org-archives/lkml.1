Return-Path: <linux-kernel-owner+w=401wt.eu-S1759782AbYF3Jwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759782AbYF3Jwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 05:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbYF3Jwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 05:52:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754716AbYF3Jwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 05:52:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <486871FC.3010300@kernel.org>
References: <486871FC.3010300@kernel.org> <486357EC.5060205@kernel.org> <21854.1214607853@redhat.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] security: filesystem capabilities bugfix2
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Mon, 30 Jun 2008 10:45:31 +0100
Message-ID: <25255.1214819131@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew G. Morgan <morgan@kernel.org> wrote:

> Within the kernel, ptraced is a more appropriate name.
> 
> Reported-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Andrew G. Morgan <morgan@kernel.org>

Acked-by: David Howells <dhowells@redhat.com>
