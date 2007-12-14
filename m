Return-Path: <linux-kernel-owner+w=401wt.eu-S1758304AbXLNHHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304AbXLNHHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 02:07:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbXLNHG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 02:06:59 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45133 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754365AbXLNHG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 02:06:58 -0500
Date: Thu, 13 Dec 2007 23:06:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Len Brown <lenb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [GIT PATCH] ACPI patches for 2.6.24-rc5
Message-Id: <20071213230643.76d196dd.akpm@linux-foundation.org>
In-Reply-To: <200712140126.12182.lenb@kernel.org>
References: <200712140126.12182.lenb@kernel.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007 01:26:11 -0500 Len Brown <lenb@kernel.org> wrote:

> please pull from: 
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
> 
> This will update the files shown below.
> 
> thanks!
> 
> -Len
> 
> ps. individual patches are available on linux-acpi@vger.kernel.org
> and a consolidated plain patch is available here:
> ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.24/acpi-release-20070126-2.6.24-rc5.diff.gz
> 
>  drivers/acpi/battery.c       |    2 +-
>  drivers/acpi/numa.c          |    4 ++--
>  drivers/acpi/video.c         |    4 ++--
>  drivers/misc/thinkpad_acpi.c |    4 ++--
>  4 files changed, 7 insertions(+), 7 deletions(-)

What's happening with Alexey's sbs regression fixes?
