Return-Path: <linux-kernel-owner+w=401wt.eu-S965945AbXCFRDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965945AbXCFRDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 12:03:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965953AbXCFRDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 12:03:53 -0500
Received: from outbound4.mail.tds.net ([216.170.230.94]:55625 "EHLO
	outbound4.mail.tds.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965945AbXCFRDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 12:03:52 -0500
Subject: Re: [PATCH] remove availability for PAGE_SIZE and friends (i386)
From: "David M. Lloyd" <dmlloyd@flurg.com>
To: David Brown <dmlb2000@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <9c21eeae0703060831k1a99bd13k1bf81afaabb6f1af@mail.gmail.com>
References: <9c21eeae0703060831k1a99bd13k1bf81afaabb6f1af@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 11:03:42 -0600
Message-Id: <1173200622.32480.23.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 08:31 -0800, David Brown wrote:
> +#define __KERNEL__

That's a #define, not an #ifdef...

- DML

