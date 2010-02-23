Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab0BWWrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 17:47:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42069 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754465Ab0BWWrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 17:47:35 -0500
Message-ID: <4B845AEE.5080604@zytor.com>
Date: Tue, 23 Feb 2010 14:47:10 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Luca Barbieri <luca@luca-barbieri.com>
CC: mingo@elte.hu, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] x86-32: improve atomic64_t functions (v2)
References: <1266600404-16402-1-git-send-email-luca@luca-barbieri.com>
In-Reply-To: <1266600404-16402-1-git-send-email-luca@luca-barbieri.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luca,

I wonder if I could ask you to recreate your patchset on top of the
x86/asm branch in the -tip tree.  There are some nontrivial changes to
the alternatives mechanism, plus a restructuring of the atomic headers
which both conflict with this patchset.

The -tip tree is available from:

git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

