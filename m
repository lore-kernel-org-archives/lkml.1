Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbZETJ1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbZETJ1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 05:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756862AbZETJ1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 05:27:21 -0400
Received: from matrixpower.ru ([195.178.208.66]:37830 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756988AbZETJ1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 05:27:20 -0400
Date: Wed, 20 May 2009 13:27:21 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] Documentation/connector/cn_test.c remove unused cn_test_want_notify()
Message-ID: <20090520092721.GA23759@ioremap.net>
References: <1242797693.3260.15.camel@localhost.localdomain> <20090520072224.GA19823@ioremap.net> <1242805348.3260.52.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242805348.3260.52.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 01:12:28PM +0530, Jaswinder Singh Rajput (jaswinder@kernel.org) wrote:
> [PATCH -tip] Documentation/connector/cn_test.c comment unused cn_test_want_notify()
> 
> Currently cn_test_want_notify() is not having any user.
> 
> So adding ifdef and comment which tells to not remove it.
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

Looks good, thank you Jaswinder.
Ack.

-- 
	Evgeniy Polyakov
