Return-Path: <linux-kernel-owner+w=401wt.eu-S1752263AbZKHPoC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbZKHPoC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 10:44:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbZKHPoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 10:44:01 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:34985 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751352AbZKHPoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 10:44:00 -0500
Date: Sun, 8 Nov 2009 10:44:03 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/23] sysctl crypto: Remove dead binary sysctl support
Message-ID: <20091108154403.GC31958@gondor.apana.org.au>
References: <m14op5jjo4.fsf@fess.ebiederm.org> <1257682930-31401-13-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257682930-31401-13-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 08, 2009 at 04:22:00AM -0800, Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Now that sys_sysctl is a generic wrapper around /proc/sys  .ctl_name
> and .strategy members of sysctl tables are dead code.  Remove them.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
