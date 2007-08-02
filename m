Return-Path: <linux-kernel-owner+w=401wt.eu-S1756555AbXHBB1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbXHBB1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 21:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbXHBB1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 21:27:07 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:16730 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136AbXHBB1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 21:27:06 -0400
Date: Wed, 1 Aug 2007 18:30:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH -mm] linux-audit list is subscribers-only
Message-Id: <20070801183030.e07ff8f5.randy.dunlap@oracle.com>
In-Reply-To: <46B11E7A.4050908@googlemail.com>
References: <20070731230932.a9459617.akpm@linux-foundation.org>
	<46B11E7A.4050908@googlemail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Aug 2007 01:59:54 +0200 Gabriel C wrote:

> Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
> 
> ---
> 
> --- linux-2.6.23-rc1-mm/MAINTAINERS.orig	2007-08-02 01:51:40.000000000 +0200
> +++ linux-2.6.23-rc1-mm/MAINTAINERS	2007-08-02 01:52:17.000000000 +0200
> @@ -672,7 +672,7 @@ S:	Maintained
>  AUDIT SUBSYSTEM
>  P:	David Woodhouse
>  M:	dwmw2@infradead.org
> -L:	linux-audit@redhat.com
> +L:	linux-audit@redhat.com (subscribers-only)
>  W:	http://people.redhat.com/sgrubb/audit/
>  T:	git kernel.org:/pub/scm/linux/kernel/git/dwmw2/audit-2.6.git
>  S:	Maintained
> 
> -

Ack, I sent this patch last week...

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
