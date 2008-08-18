Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183AbYHRQ7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbYHRQ7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbYHRQ7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:59:43 -0400
Received: from qb-out-0506.google.com ([72.14.204.239]:55208 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbYHRQ7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:59:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ms6FFL+hQOE6fpKIXpqfPSjAStwbYtj7a3n6gduK3U+djpM29n5ID4M5uc70D3GiHc
         118V5baA3vJ0/YdDtoz0B1uPSih4lWA/PA9jdgjX2XoBJStRBd9rP75viakfOTnvV31w
         gR5Mq4PUiK9B0q5gvWVwIrJgL/mV6mkqARTA8=
Date: Mon, 18 Aug 2008 20:59:58 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/15] x86: apic - rearrange maxcpu definition
Message-ID: <20080818165958.GB7237@lenovo>
References: <1219077963-22883-1-git-send-email-gorcunov@gmail.com> <8d555f8d496693d05b9e0836f18f62b1adb313c8.1219073223.git.gorcunov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d555f8d496693d05b9e0836f18f62b1adb313c8.1219073223.git.gorcunov@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Mon, Aug 18, 2008 at 08:45:49PM +0400]
| Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| ---
|  arch/x86/kernel/apic_32.c |    4 ++--
|  arch/x86/kernel/apic_64.c |    2 +-
|  2 files changed, 3 insertions(+), 3 deletions(-)
| 

Btw - it seems my patches are too 'flooding' the LKML list now.
Will _stop_ make them too small. Sorry.
 
		- Cyrill -
