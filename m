Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbYJ3Mjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbYJ3Mjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 08:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbYJ3Mjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 08:39:37 -0400
Received: from ozlabs.org ([203.10.76.45]:53889 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbYJ3Mjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 08:39:37 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 1/7] kmod: fix varargs kernel-doc
Date: Thu, 30 Oct 2008 23:39:34 +1100
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
References: <20081029223442.adacc33e.randy.dunlap@oracle.com>
In-Reply-To: <20081029223442.adacc33e.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810302339.34829.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 October 2008 16:34:42 Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Fix varargs kernel-doc format in kmod.c:
> Use @... instead of @varargs.
>
> Warning(kernel/kmod.c:67): Excess function parameter or struct member
> 'varargs' description in 'request_module'
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> cc: Rusty Russell <rusty@rustcorp.com.au>

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks!
Rusty.
