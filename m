Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbYBQS5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbYBQS5k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 13:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbYBQS5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 13:57:31 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:32871 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbYBQS5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 13:57:30 -0500
Date: Sun, 17 Feb 2008 19:57:35 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: ak@suse.de, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] x86: lds - Use PAGE_SIZE instead of numeric constant
Message-ID: <20080217185735.GA14588@uranus.ravnborg.org>
References: <20080217151716.274134094@gmail.com> <20080217151924.985325396@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217151924.985325396@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 06:17:17PM +0300, Cyrill Gorcunov wrote:
> It's much better to use PAGE_SIZE then magic 4096
> (though it's almost synonym in most cases on x86 but
> not for *all* cases ;)

Thanks Cyrill.

> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
