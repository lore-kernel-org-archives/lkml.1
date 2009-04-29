Return-Path: <linux-kernel-owner+w=401wt.eu-S1759859AbZD2LBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759859AbZD2LBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758211AbZD2KzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:55:10 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45148 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758220AbZD2KzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:55:09 -0400
Date: Wed, 29 Apr 2009 06:55:01 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] add infrastructure for ansi_cprng self-tests
Message-ID: <20090429105501.GE7227@hmsreliant.think-freely.org>
References: <200904282127.33190.jarod@redhat.com> <200904282128.14153.jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904282128.14153.jarod@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 09:28:13PM -0400, Jarod Wilson wrote:
> Add some necessary infrastructure to make it possible to run
> self-tests for ansi_cprng. The bits are likely very specific
> to the ANSI X9.31 CPRNG in AES mode, and thus perhaps should
> be named more specifically if/when we grow additional CPRNG
> support...
> 
> Successfully tested against the cryptodev-2.6 tree and a
> Red Hat Enterprise Linux 5.x kernel with the follow-on
> patch that adds the actual test vectors.
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> 
Thanks Jarod!
Acked-by: Neil Horman <nhorman@tuxdriver.com>

