Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965084Ab0BZPY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 10:24:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965022Ab0BZPY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 10:24:58 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100225181454.GA18000@redhat.com>
References: <20100225181454.GA18000@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Neil Horman <nhorman@tuxdriver.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/2] umh && creds: kill sub_info->cred
Date: Fri, 26 Feb 2010 15:24:16 +0000
Message-ID: <6983.1267197856@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> (on top of kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit.patch)

Can you send me this patch?  Your patches as they stand don't apply to the
latest Linus tree.

David
