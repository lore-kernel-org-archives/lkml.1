Return-Path: <linux-kernel-owner+w=401wt.eu-S1763081AbXGYG3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763081AbXGYG3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 02:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbXGYG3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 02:29:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60936
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752844AbXGYG3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 02:29:15 -0400
Date: Tue, 24 Jul 2007 23:29:14 -0700 (PDT)
Message-Id: <20070724.232914.56812376.davem@davemloft.net>
To: jeremy@goop.org
Cc: hpa@zytor.com, kaos@ocs.com.au, xyzzy@speakeasy.org, viro@ftp.linux.org.uk,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH][RFC] getting rid of stupid loop in BUG()
From: David Miller <davem@davemloft.net>
In-Reply-To: <46A6ECB7.7090208@goop.org>
References: <21803.1185331847@ocs10w.ocs.com.au>
	<46A6DB04.3000003@zytor.com>
	<46A6ECB7.7090208@goop.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Tue, 24 Jul 2007 23:24:55 -0700

> H. Peter Anvin wrote:
> > How far back was __builtin_trap() supported?
> 
> I think its relatively recent, but it might be within our supported
> compiler window.

I'm pretty sure it is.
