Return-Path: <linux-kernel-owner+w=401wt.eu-S1756752Ab0ANN7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab0ANN7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 08:59:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932181Ab0ANN7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 08:59:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180Ab0ANN7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 08:59:09 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100114053634.GA15972@ZenIV.linux.org.uk>
References: <20100114053634.GA15972@ZenIV.linux.org.uk> <20100108220516.23489.11319.stgit@warthog.procyon.org.uk> <23917.1262988613@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: dhowells@redhat.com, vapier@gentoo.org, lethal@linux-sh.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] NOMMU: Fix SYSV SHM for NOMMU
Date: Thu, 14 Jan 2010 13:57:25 +0000
Message-ID: <10463.1263477445@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> wrote:

> Series looks sane...  ACK on the entire bunch

Thanks!

David
