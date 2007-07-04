Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbXGDEEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbXGDEEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 00:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750891AbXGDEEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 00:04:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55779 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750707AbXGDEEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 00:04:34 -0400
Date: Tue, 3 Jul 2007 21:04:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc6-mm1 -- Problems with suspend/resume.
Message-Id: <20070703210426.9d1ec62f.akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0707032045wa35095dg794608c2fd6d6633@mail.gmail.com>
References: <a44ae5cd0707031809p3d7c3b68gf2d5633736bb4f3@mail.gmail.com>
	<20070703183406.3cd17bc6.akpm@linux-foundation.org>
	<a44ae5cd0707032045wa35095dg794608c2fd6d6633@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2007 20:45:41 -0700 "Miles Lane" <miles.lane@gmail.com> wrote:

> Should I not report stuff like this when it is
> generated after an OOPS?

All bets are off if the kernel has oopsed.  Reboot, see if
the bug still happens without the earlier oops, perhaps.
