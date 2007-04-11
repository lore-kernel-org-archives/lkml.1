Return-Path: <linux-kernel-owner+w=401wt.eu-S1751956AbXDKK5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbXDKK5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 06:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbXDKK5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 06:57:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbXDKK5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 06:57:02 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1176284415.29581.30.camel@roc-desktop> 
References: <1176284415.29581.30.camel@roc-desktop> 
To: bryan.wu@analog.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 5/5] nommu: fix bug ip_conntrack does not work on nommu 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Wed, 11 Apr 2007 11:56:50 +0100
Message-ID: <15138.1176289010@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wu, Bryan <bryan.wu@analog.com> wrote:

> num_physpages is not exported out in mm/nommu.c, so the ip_conntrack
> module link will fail.

Fine by me.

Acked-By: David Howells <dhowells@redhat.com>
