Return-Path: <linux-kernel-owner+w=401wt.eu-S1764645AbXHVQKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764645AbXHVQKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 12:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763592AbXHVQKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 12:10:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52717 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763429AbXHVQKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 12:10:03 -0400
Date: Wed, 22 Aug 2007 09:09:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3-mm1
Message-Id: <20070822090953.78a3d90c.akpm@linux-foundation.org>
In-Reply-To: <46CC3B27.10604@googlemail.com>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<46CC3B27.10604@googlemail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007 15:33:27 +0200 Gabriel C <nix.or.die@googlemail.com> wrote:

> 
> ...
> 
>  CC      arch/i386/boot/cpu.o
>   CC      arch/i386/boot/cpucheck.o
> WARNING: "div64_64" [net/netfilter/xt_connbytes.ko] has no CRC!
>   CC      arch/i386/boot/edd.o
>   AS      arch/i386/boot/header.o
>   CC      arch/i386/boot/main.o

Yeah, I get that too.  I was hoping that someone who had a vague clue
about what's causing it might fix it also.

> ...
> 
> config : http://194.231.229.228/kernel/mm/2.6.23-rc3-mm1/config
> build-log: http://194.231.229.228/kernel/mm/2.6.23-rc3-mm1/build-log
> 
> Regards,
> 
> Gabriel
