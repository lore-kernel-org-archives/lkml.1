Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965348Ab0BZQfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 11:35:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965292Ab0BZQfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 11:35:15 -0500
Date: Fri, 26 Feb 2010 17:33:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Neil Horman <nhorman@tuxdriver.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/2] umh && creds: kill sub_info->cred
Message-ID: <20100226163356.GA26771@redhat.com>
References: <20100225181454.GA18000@redhat.com> <6983.1267197856@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6983.1267197856@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > (on top of kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit.patch)
>
> Can you send me this patch?  Your patches as they stand don't apply to the
> latest Linus tree.

I guess you need 5 patches from -mm, I'll send you them privately
in a minute...

Oleg.

