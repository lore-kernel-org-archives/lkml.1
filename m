Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab0CIT6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 14:58:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751121Ab0CIT6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 14:58:07 -0500
Date: Tue, 9 Mar 2010 11:57:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 01/11] lib: introduce common method to convert hex
 digits
Message-Id: <20100309115743.48cc125b.akpm@linux-foundation.org>
In-Reply-To: <5ec8ebd51003081703r76fd2ba7pa850f7568a580181@mail.gmail.com>
References: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
	<d8c224af14aa936dcd692c70656559fe9726d997.1266861291.git.ext-andriy.shevchenko@nokia.com>
	<5ec8ebd51003081703r76fd2ba7pa850f7568a580181@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Mar 2010 03:03:05 +0200
Andy Shevchenko <andy.shevchenko@gmail.com> wrote:

> On Mon, Feb 22, 2010 at 8:09 PM, Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
> > hex_to_bin() is a little method which converts hex digit to its actual value.
> > There are plenty of places where such functionality is needed.
> 
> I found another more than 10 places (roughly there are > 20 of them
> already) with such 'copy-paste' logic. Still waiting decision to
> include first patch of this series... Any comments, suggestions?

This patch series turned up two days before the 2.6.33 release, which
is fairly exactly the time when non-bugfixes won't get looked at!  I
stored it all away for consideration after we've finished the
2.6.34-rc1 merge scramble.

