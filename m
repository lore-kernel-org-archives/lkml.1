Return-Path: <linux-kernel-owner+w=401wt.eu-S1756652AbYDYAPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbYDYAPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 20:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755586AbYDYAPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 20:15:35 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:55966 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593AbYDYAPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 20:15:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=GEObVTjPGrrXWrkomSocThkInff9w7EmaN0FF1xoNPj2NZonE3m62sszoWkms
	r8M4ifdeIbZdlsGScp1PehLDg==
Date: Fri, 25 Apr 2008 02:15:31 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>,
       Ben Dooks <ben-linux@fluff.org>, Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH 01/24] types: create <asm-generic/int-*.h>
Message-ID: <20080425001531.GC29618@xi.wantstofly.org>
References: <1209078352-7593-1-git-send-email-hpa@zytor.com> <1209078352-7593-2-git-send-email-hpa@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209078352-7593-2-git-send-email-hpa@zytor.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 04:05:08PM -0700, H. Peter Anvin wrote:

> This creates two generic files with common integer definitions; one
> where 64 bits is "long" (most 64-bit architectures) and one where 64
> bits is "long long" (all 32-bit architectures and x86-64.)

Acked-by: Lennert Buytenhek <kernel@wantstofly.org>
