Return-Path: <linux-kernel-owner+w=401wt.eu-S932967AbZLFNzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967AbZLFNzK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 08:55:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932209AbZLFNzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 08:55:09 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38506 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163AbZLFNzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 08:55:08 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5823"; a="29198730"
Subject: Re: tree with htc dream support
From: Daniel Walker <dwalker@codeaurora.org>
To: Brian Swetland <swetland@google.com>
Cc: Pavel Machek <pavel@ucw.cz>, Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Iliyan Malchev <malchev@google.com>, linux-kernel@codeaurora.org
In-Reply-To: <a55d774e0912051638u7858878cg7cf62905c3c005c1@mail.gmail.com>
References: <20091205221100.GA32522@elf.ucw.cz>
	 <1260054737.23633.35.camel@desktop>
	 <a55d774e0912051638u7858878cg7cf62905c3c005c1@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 06 Dec 2009 05:55:07 -0800
Message-Id: <1260107707.23633.59.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-12-05 at 16:38 -0800, Brian Swetland wrote:
> On Sat, Dec 5, 2009 at 3:12 PM, Daniel Walker <dwalker@codeaurora.org>
> wrote:
>         https://www.codeaurora.org/gitweb/quic/kernel/?p=dwalker/linux-msm.git;a=shortlog;h=refs/heads/testing
>         
>         It's been in Linux-next for maybe two weeks .. I've been
>         trying to
>         decide if I should submit it for 2.6.33. I'm going to be
>         adding boat
>         loads of additional msm code and doing a fairly large merge
>         for
>         2.6.34 .. So your code would get better testing if we wait for
>         that.
>         
>         However, If you really want it in 2.6.33 I'll try to
>         accommodate you.
> 
> Arve's about to take our common and msm trees and rebase them over
> the .32, which may be useful for reference -- at least as a snapshot
> of a fully functional set of patches that android donut and eclair run
> on, on production hardware.  We'll make that available as soon as we
> have something that's bootable.

Ok .. I'm mainly working with a small subset of a full Android tree.
It's just isolated to the arch/arm/mach-msm/ directory (some in
arch/arm/) .. If you guys have changes to that area just let me know
where they are and I'll try to move them forward.

Daniel

