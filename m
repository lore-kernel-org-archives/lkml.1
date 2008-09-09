Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbYIITSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbYIITSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 15:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbYIITSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 15:18:23 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:50632 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbYIITSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 15:18:22 -0400
From: David Sanders <linux@sandersweb.net>
Reply-To: linux@sandersweb.net
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 fixes
Date: Tue, 9 Sep 2008 15:18:15 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>
References: <200809081932.m88JWVZG013061@askone.hos.anvin.org>
In-Reply-To: <200809081932.m88JWVZG013061@askone.hos.anvin.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809091518.16311.linux@sandersweb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 September 2008 15:32, H. Peter Anvin wrote:
> Please pull the latest x86-fixes-for-linus git tree from:
> ------------------>
> H. Peter Anvin (1):
>       x86: prevent binutils from being "smart" and generating NOPLs for us
>
> Jeremy Fitzhardinge (1):
>       xen: fix 2.6.27-rc5 xen balloon driver warnings
>
> Linus Torvalds (1):
>       x86: disable static NOPLs on 32 bits
>

I haven't seen this come across the wire in Linus's 2.6.27 tree.  We're still 
going to do this right?
David
