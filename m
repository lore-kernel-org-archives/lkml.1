Return-Path: <linux-kernel-owner+w=401wt.eu-S1764434AbXINAya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764434AbXINAya (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 20:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756244AbXINAyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 20:54:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755598AbXINAyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 20:54:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070913232856.GE5764@devil>
References: <20070913232856.GE5764@devil>
To: aherrman@arcor.de
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: Commit 02a5e0acb3cb85d80d0fe834e366d38a92bbaa22 might break kernel build
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Fri, 14 Sep 2007 01:53:39 +0100
Message-ID: <7260.1189731219@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

aherrman@arcor.de wrote:

> Due to commit 02a5e0acb3cb85d80d0fe834e366d38a92bbaa22
> kernel build is broken if (CONFIG_COMPAT && ! CONFIG_BLOCK):
> ...
> ... or better apply the attached patch to fix it.

Acked-By: David Howells <dhowells@redhat.com>
