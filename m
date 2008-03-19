Return-Path: <linux-kernel-owner+w=401wt.eu-S1759983AbYCSTv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983AbYCSTv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756068AbYCSTeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:34:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756055AbYCSTd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:33:59 -0400
Date: Wed, 19 Mar 2008 11:39:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Trivial patch monkey <trivial@kernel.org>, ak@suse.de,
       linux-bluetooth@vger.kernel.org
Subject: Re: MAINTAINERS: bluez-devel is subscribers-only
Message-Id: <20080319113943.a156e76e.akpm@linux-foundation.org>
In-Reply-To: <20080319142703.GA25773@elf.ucw.cz>
References: <20080319142703.GA25773@elf.ucw.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2008 15:27:03 +0100 Pavel Machek <pavel@ucw.cz> wrote:

> 
> Document subscribers-only bluetooth mailing list.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> ---
> commit d5ac3c822e1036165b92d62e464be1e61c12d757
> tree a5c8b5f46dc0f0c94889b7eda68abe334a2d8d59
> parent a1171bebd79cde255d3fa73a86eeab808ab09fe6
> author Pavel <pavel@amd.ucw.cz> Wed, 19 Mar 2008 15:26:41 +0100
> committer Pavel <pavel@amd.ucw.cz> Wed, 19 Mar 2008 15:26:41 +0100
> 
>  MAINTAINERS |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6d628fb..9c1332e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -880,7 +880,7 @@ P:	Marcel Holtmann
>  M:	marcel@holtmann.org
>  P:	Maxim Krasnyansky
>  M:	maxk@qualcomm.com
> -L:	bluez-devel@lists.sf.net
> +L:	bluez-devel@lists.sf.net (subscribers-only)
>  W:	http://bluez.sf.net
>  W:	http://www.bluez.org
>  W:	http://www.holtmann.org/linux/bluetooth/

bluez-devel is apparently a spamhole too.  linux-bluetooth@vger.kernel.org
has been set up and we're supposed to be migrating to it.
