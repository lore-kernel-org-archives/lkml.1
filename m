Return-Path: <linux-kernel-owner+w=401wt.eu-S1753568Ab0A0Of3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab0A0Of3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 09:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301Ab0A0Of2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 09:35:28 -0500
Received: from mail.perches.com ([173.55.12.10]:1505 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169Ab0A0Of2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 09:35:28 -0500
Subject: Re: + drivers-block-floppyc-use-pr_level.patch added to -mm tree
From: Joe Perches <joe@perches.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, bzolnier@gmail.com, jens.axboe@oracle.com,
       marcin.slusarz@gmail.com, shemminger@vyatta.com
In-Reply-To: <4B604BD6.1010205@gmail.com>
References: <201001270037.o0R0bN6S032517@imap1.linux-foundation.org>
	 <4B600806.4010003@gmail.com> <1264601340.14552.55.camel@Joe-Laptop.home>
	 <4B604BD6.1010205@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jan 2010 06:35:26 -0800
Message-ID: <1264602926.14552.61.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-27 at 15:21 +0100, Jiri Slaby wrote:
> On 01/27/2010 03:09 PM, Joe Perches wrote:
> > It does add an always output decimal value to the DPRINT
> > instead of a mostly mismatched format and argument
> > 	printk(message, marg).
> So if I understand correctly, it now prints the third argument every time.

correct.



