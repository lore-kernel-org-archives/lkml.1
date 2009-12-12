Return-Path: <linux-kernel-owner+w=401wt.eu-S1761616AbZLLFmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761616AbZLLFmD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 00:42:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758095AbZLLFmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 00:42:01 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:37321 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757838AbZLLFmA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 00:42:00 -0500
MIME-Version: 1.0
In-Reply-To: <a55d774e0912051638u7858878cg7cf62905c3c005c1@mail.gmail.com>
References: <20091205221100.GA32522@elf.ucw.cz>
	 <1260054737.23633.35.camel@desktop>
	 <a55d774e0912051638u7858878cg7cf62905c3c005c1@mail.gmail.com>
Date: Fri, 11 Dec 2009 21:42:07 -0800
Message-ID: <d6200be20912112142r7bdf8f18o31edd4457aa64998@mail.gmail.com>
Subject: Re: tree with htc dream support
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Brian Swetland <swetland@google.com>
Cc: Daniel Walker <dwalker@codeaurora.org>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Iliyan Malchev <malchev@google.com>, linux-kernel@codeaurora.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 5, 2009 at 4:38 PM, Brian Swetland <swetland@google.com> wrote:
> Arve's about to take our common and msm trees and rebase them over the .32,
> which may be useful for reference -- at least as a snapshot of a fully
> functional set of patches that android donut and eclair run on, on
> production hardware.  We'll make that available as soon as we have something
> that's bootable.
>
> Brian
>
>

A first pass of this is available in the android-msm-2.6.32-test1
branch at git://android.git.kernel.org/kernel/experimental.git.

http://android.git.kernel.org/?p=kernel/experimental.git;a=shortlog;h=refs/heads/android-msm-2.6.32-test1

-- 
Arve Hjønnevåg
