Return-Path: <linux-kernel-owner+w=401wt.eu-S1764102AbYDVNae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764102AbYDVNae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbYDVNaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:30:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754282AbYDVNaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:30:25 -0400
Date: Tue, 22 Apr 2008 06:29:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@elte.hu, bunk@kernel.org, astarikovskiy@suse.de, tglx@linutronix.de,
       James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: Voyager phys_cpu_present_map compile error
Message-Id: <20080422062927.bb360a36.akpm@linux-foundation.org>
In-Reply-To: <480C8EC8.3080705@zytor.com>
References: <20080421000238.GD26897@cs181133002.pp.htv.fi>
	<20080421085314.GI26897@cs181133002.pp.htv.fi>
	<20080421120054.GA6788@elte.hu>
	<480C8EC8.3080705@zytor.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 21 Apr 2008 08:55:36 -0400 "H. Peter Anvin" <hpa@zytor.com> wrote:
>
> If there are no VISWS' left, we should just unload the code.

yup, it's a desirable objective.

I have a suspicion that there are no NUMAQs left either.  Andy, would it be
missed?

