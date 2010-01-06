Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984Ab0AFR0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab0AFR0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 12:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898Ab0AFR0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 12:26:47 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:47430 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411Ab0AFR0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 12:26:45 -0500
Date: Thu, 7 Jan 2010 02:26:39 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       uclinux-dev@uclinux.org, Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
Subject: Re: [PATCH 4/4] elf_fdpic_core_dump(): fix build break in 2.6.33-rc1
Message-ID: <20100106172638.GA20417@linux-sh.org>
References: <20100106172317.25862.64950.stgit@warthog.procyon.org.uk> <20100106172333.25862.40963.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100106172333.25862.40963.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 05:23:33PM +0000, David Howells wrote:
> From: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
> 
> Commit f6151dfea21496d43dbaba32cfcd9c9f404769bc causes ELF-FDPIC to break
> during building, so this patch fixes it together with a correction for the
> printk format.
> 
> Signed-off-by: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
> Reviewed-by: Masami Hiramatsu <mhiramat@redhat.com>
> Acked-by: Paul Mundt <lethal@linux-sh.org>
> Signed-off-by: David Howells <dhowells@redhat.com>

I already pushed this through my tree, so you can just ignore this one.
