Return-Path: <linux-kernel-owner+w=401wt.eu-S1755106AbYJWGSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbYJWGSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 02:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbYJWGSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 02:18:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:36337 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbYJWGSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 02:18:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LpOzsQ4f5KTs6eElcR6APm7k8ZeE6XSkIukLHVeJ9jnv747peHgQBWdhYl58xKCTrg
         RN6uybVCcG9Bp3AEKIvUursUQSrBwAwrz+HmuxahZh7J7nJKJctzGBwsG2tGgALJCcBz
         2eqGrK9vZlcXjGIuJdG/3+GTb02cCUgkXpIUc=
Date: Thu, 23 Oct 2008 10:21:43 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] get rid if __cpuinit and __cpuexit
Message-ID: <20081023062143.GA2981@x200.localdomain>
References: <20081022153054.335ce51e@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022153054.335ce51e@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 03:30:54PM -0700, Arjan van de Ven wrote:
> Subject: [PATCH] get rid if __cpuinit and __cpuexit

Aiee!

Was something said about __devinit/__devexit ?
