Return-Path: <linux-kernel-owner+w=401wt.eu-S1757991AbXKUPtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991AbXKUPtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 10:49:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbXKUPsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 10:48:54 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38753 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754977AbXKUPsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 10:48:53 -0500
Date: Wed, 21 Nov 2007 09:48:49 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: casey@schaufler-ca.com, chrisw@sous-sol.org, darwish.07@gmail.com,
       jmorris@namei.org, method@manicmethod.com, morgan@kernel.org,
       paul.moore@hp.com, sds@tycho.nsa.gov
Subject: Re: +
	smack-version-11c-simplified-mandatory-access-control-kernel.patch
	added to -mm tree
Message-ID: <20071121154849.GA7195@sergelap.austin.ibm.com>
References: <200711202206.lAKM6BlW025868@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711202206.lAKM6BlW025868@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting akpm@linux-foundation.org (akpm@linux-foundation.org):
> +/*
> + * There are not enough CAP bits available to make this
> + * real, so Casey borrowed the capability that looks to
> + * him like it has the best balance of similarity amd
> + * low use.
> + */
> +#define CAP_MAC_OVERRIDE CAP_LINUX_IMMUTABLE

Hey Casey,

note that 64-bit capabilities are now in -mm, so you could grab your own
capability.

-serge
