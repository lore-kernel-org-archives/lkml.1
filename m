Return-Path: <linux-kernel-owner+w=401wt.eu-S1751849AbZLCFvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbZLCFvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 00:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbZLCFu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 00:50:59 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:56331 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751344AbZLCFu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 00:50:59 -0500
Date: Thu, 3 Dec 2009 13:51:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ian Molton <ian.molton@collabora.co.uk>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCH] hw_random: prevent too-small buffer sizes
Message-ID: <20091203055103.GA16078@gondor.apana.org.au>
References: <1259758238-3507-1-git-send-email-ian.molton@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259758238-3507-1-git-send-email-ian.molton@collabora.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 12:50:38PM +0000, Ian Molton wrote:
> 	This patch prevents the hw_random core using too small of a buffer
> on machines with small cacheline sizes.
> 
> Signed-off-by: Ian Molton <ian.molton@collabora.co.uk>

Applied to cryptodev-2.6.  Thanks Ian.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
