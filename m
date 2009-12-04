Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbZLDV5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbZLDV5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 16:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757322AbZLDV5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 16:57:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757298AbZLDV5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 16:57:31 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <32275.1259923944@redhat.com>
References: <32275.1259923944@redhat.com> <20091203194300.8491.22110.stgit@paris.rdu.redhat.com>
To: Eric Paris <eparis@redhat.com>
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       akpm@linux-foundation.org, gyang@blackfin.uclinux.org,
       john.johansen@canonical.com
Subject: Re: [PATCH] security: do not check mmap_min_addr on nommu systems
Date: Fri, 04 Dec 2009 21:55:28 +0000
Message-ID: <18885.1259963728@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> Also, the big banner comment in security.h that describes all the function
> pointers does not make any mention of this argument.  Can you fix that too,
> please?

Ignore that.  I missed the bit of the patch where it was dealing with that.

David
