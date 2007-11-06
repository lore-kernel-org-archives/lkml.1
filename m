Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbXKFUcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbXKFUcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 15:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754768AbXKFUcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 15:32:32 -0500
Received: from www.tglx.de ([62.245.132.106]:50730 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755337AbXKFUcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 15:32:31 -0500
Date: Tue, 6 Nov 2007 21:32:12 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Robert Richter <robert.richter@amd.com>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/6] x86: apicdef.h unification
In-Reply-To: <20071106183645.951275000@amd.com>
Message-ID: <alpine.LFD.0.9999.0711062130200.3628@localhost.localdomain>
References: <20071106183645.951275000@amd.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert,

On Tue, 6 Nov 2007, Robert Richter wrote:

> The following patch series unifies apicdef*h header files for the x86
> architure. For a better review there are many small patches.


Thanks for doing this, but please check the x86 git repository
(cleanup / mm branch) for stuff which has been worked on already.

Maybe we need some coordination for this.

Thanks,

	tglx
