Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab0CIV0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 16:26:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab0CIV0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 16:26:12 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1268089894-28691-1-git-send-email-chihau@gmail.com>
References: <1268089894-28691-1-git-send-email-chihau@gmail.com>
To: Chihau Chau <chihau@gmail.com>
Cc: dhowells@redhat.com, jmorris@namei.org, paulmck@linux.vnet.ibm.com,
       mingo@elte.hu, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Security: key: keyring: fix some code style issues
Date: Tue, 09 Mar 2010 21:25:49 +0000
Message-ID: <6837.1268169949@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chihau Chau <chihau@gmail.com> wrote:

> From: Chihau Chau <chihau@gmail.com>
> 
> This fixes to include <linux/uaccess.h> instead <asm/uaccess.h> and some
> code style issues like to put a else sentence below close brace '}' and
> to replace a tab instead of some space characters.
> 
> Signed-off-by: Chihau Chau <chihau@gmail.com>

Acked-by: David Howells <dhowells@redhat.com>
