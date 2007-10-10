Return-Path: <linux-kernel-owner+w=401wt.eu-S1754379AbXJJHma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbXJJHma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 03:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbXJJHmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 03:42:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45407 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752414AbXJJHmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 03:42:21 -0400
Date: Wed, 10 Oct 2007 00:42:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Len Brown <lenb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] ACPI paches for 2.6.24-rc0
Message-Id: <20071010004204.3ae1f7c0.akpm@linux-foundation.org>
In-Reply-To: <200710092310.48143.lenb@kernel.org>
References: <200710092310.48143.lenb@kernel.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2007 23:10:47 -0400 Len Brown <lenb@kernel.org> wrote:

> please pull from: 
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
> 
> ...
>
>  drivers/acpi/battery.c             | 1038 +++++--------

Does this introduce the problem which Zan Lynx reported in his
unresponded-to email titled "2.6.23-rc8-mm2 ACPI Battery Info in /sys but
not /proc/acpi"?


