Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586AbXJCAPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbXJCAPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 20:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbXJCAPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 20:15:11 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:13279 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbXJCAPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 20:15:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=eBmuUgb5QzDBAmLlRJYumAgbMYCtYL3hrQ7LzkDrxVhjxPSRd/mJQrdslhGWZUoZPv1O5V25wBqOvXbm7a6n2r4Y2nb3kqxoFLa8QBYnLsiOstBseJEDbhdsUMSjKOpkniSXpXKXpzODx4d82YCiriXvRzErsObi5AmtpBYSVag=
Subject: Re: [Linux-fbdev-devel] [PATCH 0/6] Patch series to add
	of_platform binding to xilinxfb
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akonovalov@ru.mvista.com,
       linuxppc <linuxppc@ozlabs.org>,
       Grant Likely <grant.likely@secretlab.ca>
In-Reply-To: <20071001155024.6114.47993.stgit@trillian.cg.shawcable.net>
References: <20071001155024.6114.47993.stgit@trillian.cg.shawcable.net>
Content-Type: text/plain
Date: Wed, 03 Oct 2007 08:15:02 +0800
Message-Id: <1191370502.5238.1.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-01 at 09:57 -0600, Grant Likely wrote:
> (resend due to mailer issues.  Apologies to anyone receiving this twice)
> 
> This patch series reworks the Xilinx framebuffer driver and then adds
> an of_platform bus binding.  The of_platform bus binding is needed to use
> the driver in arch/powerpc platforms.
> 
> Antonino,
> 
> Assuming there are no major issues, I'd like to get this patch series
> queued up for inclusion in 2.6.24.

Okay.

Tony


