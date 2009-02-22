Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602AbZBVAib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbZBVAib (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 19:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbZBVAiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 19:38:22 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38160 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692AbZBVAiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 19:38:22 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090222001257.GA15755@x200.localdomain>
References: <20090222001257.GA15755@x200.localdomain>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: dhowells@redhat.com, kosaki.motohiro@jp.fujitsu.com, serue@us.ibm.com,
       mingo@elte.hu, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: Broken "User namespaces: Only put the userns when we unhash the uid"
Date: Sun, 22 Feb 2009 00:37:59 +0000
Message-ID: <6395.1235263079@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@gmail.com> wrote:

> The following commit breaks clone(CLONE_NEWUSER)
> with an oops.

Can you give the actual text of the oops, please?

David
