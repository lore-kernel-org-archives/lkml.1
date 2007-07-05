Return-Path: <linux-kernel-owner+w=401wt.eu-S1762735AbXGEVe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762735AbXGEVe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 17:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762098AbXGEVen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 17:34:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57980 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761709AbXGEVem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 17:34:42 -0400
Date: Thu, 5 Jul 2007 14:34:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Denis Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org, "Douglas W. Jones" <jones@cs.uiowa.edu>
Subject: Re: [PATCH 2/2] vsprintf.c: optimizing, part 2: base 10 conversion
 speedup, v2
Message-Id: <20070705143419.f214f5b2.akpm@linux-foundation.org>
In-Reply-To: <200707051251.52891.vda.linux@googlemail.com>
References: <200707051251.52891.vda.linux@googlemail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jul 2007 12:51:52 +0200
Denis Vlasenko <vda.linux@googlemail.com> wrote:

> Using code from
> 
> http://www.cs.uiowa.edu/~jones/bcd/decimal.html
> (with permission from the author, Douglas W. Jones)

Neither of your patches had signed-off-by:s.  Would prefer that they were
included please, given that we're adding stuff from someone's website.
