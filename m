Return-Path: <linux-kernel-owner+w=401wt.eu-S1758998AbZLKSf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758998AbZLKSf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 13:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756683AbZLKSfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 13:35:24 -0500
Received: from waste.org ([173.11.57.241]:39550 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753873AbZLKSfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 13:35:24 -0500
Subject: Re: hwrng: pasemi - Use __devexit_p
From: Matt Mackall <mpm@selenic.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20091211152947.GA1012@gondor.apana.org.au>
References: <20091211152947.GA1012@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Dec 2009 12:35:25 -0600
Message-ID: <1260556525.24459.1234.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-11 at 23:29 +0800, Herbert Xu wrote:
> Found this while trying to track down section mismatches in hwrng.

Gotta love those.

Acked-by: Matt Mackall <mpm@selenic.com>

-- 
http://selenic.com : development and support for Mercurial and Linux


