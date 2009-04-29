Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbZD2Kgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbZD2Kgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 06:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbZD2Kgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:36:33 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54257 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbZD2Kgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:36:32 -0400
Date: Wed, 29 Apr 2009 06:36:23 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: catch base cipher self-test failures in fips
	mode
Message-ID: <20090429103623.GB7227@hmsreliant.think-freely.org>
References: <200904282111.52074.jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904282111.52074.jarod@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 09:11:51PM -0400, Jarod Wilson wrote:
> I think this might have already been posted by Neil Horman, and
> we already have it in the Red Hat Enterprise Linux 5.x kernels,
> but in fips mode, we need to panic on the base cipher self-tests
> failing as well as the later tests.
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> 
I did post it:
http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg02307.html
looks like it somehow just never made it to Linus.  Thanks for noticing, Jarod.

Acked-by: Neil Horman <nhorman@tuxdriver.com>

> 
