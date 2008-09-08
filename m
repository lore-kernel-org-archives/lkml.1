Return-Path: <linux-kernel-owner+w=401wt.eu-S1754383AbYIHPDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383AbYIHPDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 11:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754602AbYIHPCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 11:02:55 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:40857 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbYIHPCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 11:02:54 -0400
From: David Sanders <linux@sandersweb.net>
Reply-To: linux@sandersweb.net
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 fixes (NOPL issue)
Date: Mon, 8 Sep 2008 11:02:49 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>
References: <200809060222.m862MVtP024813@askone.hos.anvin.org>
In-Reply-To: <200809060222.m862MVtP024813@askone.hos.anvin.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809081102.49636.linux@sandersweb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 September 2008 22:22, H. Peter Anvin wrote:
> This fixes the NOPL issue by detecting it explicitly.  I don't have
> access to Virtual PC, but this works on Virtual Server 2005 R2 which
> has the same issue.  These changes have been in -tip since August 18,
> so they have had some reasonable degree of exposure already.
>

We it be possible to send these fixes back the stable trees 2.6.26.y and 
2.6.25.y?

David
