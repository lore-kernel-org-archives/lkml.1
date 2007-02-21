Return-Path: <linux-kernel-owner+w=401wt.eu-S964839AbXBVJzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964839AbXBVJzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 04:55:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965070AbXBVJzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 04:55:17 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1077 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964839AbXBVJzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 04:55:15 -0500
Date: Wed, 21 Feb 2007 10:37:33 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@osdl.org, mingo@elte.hu
Subject: Re: [PATCH 10/13] KVM: Wire up hypercall handlers to a central arch-independent location
Message-ID: <20070221103733.GI3945@ucw.cz>
References: <45D979D3.2020907@qumranet.com> <20070219103052.4D23725016B@il.qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070219103052.4D23725016B@il.qumranet.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-02-19 10:30:52, Avi Kivity wrote:
> Signed-off-by: Avi Kivity <avi@qumranet.com>

changelog?

> +	switch (nr) {
> +	default:
> +		;
> +	}

Eh?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
