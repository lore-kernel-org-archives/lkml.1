Return-Path: <linux-kernel-owner+w=401wt.eu-S1753129AbYKZH4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbYKZH4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 02:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbYKZH4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 02:56:43 -0500
Received: from ozlabs.org ([203.10.76.45]:51757 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbYKZH4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 02:56:43 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 1/1] Slight fix for locking-fix patch to remove compiler warning
Date: Wed, 26 Nov 2008 18:26:36 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <200811250238.53883.rusty@rustcorp.com.au> <200811250959.20652.rusty@rustcorp.com.au> <492C2E0B.4020209@sgi.com>
In-Reply-To: <492C2E0B.4020209@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811261826.36324.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 November 2008 03:25:39 Mike Travis wrote:
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>
> Remove rq since it's no longer referenced.

Thanks.  Ubuntu's gcc spews lots of warnings; get easy to miss them :(

Praying for Ingo's warning tree merge soon...
Rusty.
