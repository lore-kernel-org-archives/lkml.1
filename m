Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbZETHWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbZETHWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 03:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbZETHWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 03:22:25 -0400
Received: from broadrack.ru ([195.178.208.66]:39098 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761AbZETHWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 03:22:24 -0400
Date: Wed, 20 May 2009 11:22:24 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] Documentation/connector/cn_test.c remove unused cn_test_want_notify()
Message-ID: <20090520072224.GA19823@ioremap.net>
References: <1242797693.3260.15.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242797693.3260.15.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 11:04:53AM +0530, Jaswinder Singh Rajput (jaswinder@kernel.org) wrote:
> 
> Currently cn_test_want_notify() is not having any user.

Do not remove it, disable with ifdef if you want, it is an example
of how to get notifications about new connector user registration.

-- 
	Evgeniy Polyakov
