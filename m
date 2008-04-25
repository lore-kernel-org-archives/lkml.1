Return-Path: <linux-kernel-owner+w=401wt.eu-S1755056AbYDYAPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbYDYAPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 20:15:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbYDYAOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 20:14:52 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:47497 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbYDYAOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 20:14:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=no1PcztUPGfY41+JzD6qrnxSeRG087+sJxLyAsjXELUpZ5ulKnHge2JSLOv1/
	P1qw5ddvpe1O0ENI8lH4xDU4g==
Date: Fri, 25 Apr 2008 02:14:48 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH 03/24] arm: types: use <asm-generic/int-*.h> for the arm architecture
Message-ID: <20080425001448.GB29618@xi.wantstofly.org>
References: <1209078352-7593-1-git-send-email-hpa@zytor.com> <1209078352-7593-2-git-send-email-hpa@zytor.com> <1209078352-7593-3-git-send-email-hpa@zytor.com> <1209078352-7593-4-git-send-email-hpa@zytor.com> <1209078352-7593-5-git-send-email-hpa@zytor.com> <1209078352-7593-6-git-send-email-hpa@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209078352-7593-6-git-send-email-hpa@zytor.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 04:05:12PM -0700, H. Peter Anvin wrote:

> This modifies <asm-arm/types.h> to use the <asm-generic/int-*.h>
> generic include files.
> 
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> Cc: Russell King <rmk@arm.linux.org.uk>
> Cc: Lennert Buytenhek <kernel@wantstofly.org>
> Cc: Ben Dooks <ben-linux@fluff.org>

Acked-by: Lennert Buytenhek <kernel@wantstofly.org>
