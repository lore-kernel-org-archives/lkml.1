Return-Path: <linux-kernel-owner+w=401wt.eu-S1757406AbYA0GDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbYA0GDi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 01:03:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756151AbYA0GDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 01:03:07 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46014 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757122AbYA0GDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 01:03:05 -0500
Date: Sat, 26 Jan 2008 22:01:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Konrad Rzeszutek <konrad@darnok.org>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, dwm@enoyolf.org,
       darnok@68k.org, pjones@redhat.com, konradr@redhat.com,
       konradr@linux.vnet.ibm.com, randy.dunlap@oracle.com, hpa@zytor.com,
       lenb@kernel.org, mike.anderson@us.ibm.com, dwm@austin.ibm.com,
       arjan@infradead.org
Subject: Re: [PATCH] Add iSCSI iBFT support (v0.4.5)
Message-Id: <20080126220112.5fa0de33.akpm@linux-foundation.org>
In-Reply-To: <20080125220629.GA25325@andromeda.dapyr.net>
References: <20080125220629.GA25325@andromeda.dapyr.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please always include a diffstat with non-trivial patches.

> On Fri, 25 Jan 2008 18:06:29 -0400 Konrad Rzeszutek <konrad@darnok.org> wrote:
> --- a/arch/x86/kernel/setup_32.c
> +++ b/arch/x86/kernel/setup_32.c

lol.  You touched x86 code.

<goes off to fix the inevitable rejects>
