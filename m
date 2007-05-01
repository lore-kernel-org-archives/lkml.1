Return-Path: <linux-kernel-owner+w=401wt.eu-S1030323AbXEAKb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030323AbXEAKb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031144AbXEAKb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:31:29 -0400
Received: from mail.gmx.net ([213.165.64.20]:45459 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1030323AbXEAKb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:31:26 -0400
X-Authenticated: #24128601
X-Provags-ID: V01U2FsdGVkX19mdXR5VrtmeWZUp83HThkgzpkN4EMKtAe3e2tagm
	jNcC7thOpKhV+B
Date: Tue, 1 May 2007 12:32:01 +0200
From: Sebastian Kemper <sebastian_ml@gmx.net>
To: linux-kernel@vger.kernel.org
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Alexey Starikovskiy <aystarik@gmail.com>
Subject: Re: 2.6.21: ACPI related kernel panic
Message-ID: <20070501103201.GA4661@anna.darkstar.lan>
Mail-Followup-To: Sebastian Kemper <sebastian_ml@gmx.net>,
	linux-kernel@vger.kernel.org,
	Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
	Alexey Starikovskiy <aystarik@gmail.com>
References: <20070430122940.GA25848@anna.darkstar.lan> <6bffcb0e0704300546w1eff1a92gff047117e9e756e@mail.gmail.com> <8f8ff01d0704300551yb0413c7m3834cc75c2d0fcdd@mail.gmail.com> <6bffcb0e0704300634y610aee9en1e5bd8366d30a0e0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0704300634y610aee9en1e5bd8366d30a0e0@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 03:34:29PM +0200, Michal Piotrowski wrote:
> Sebastian, please test both patches.
> http://bugzilla.kernel.org/attachment.cgi?id=11331&action=view
> http://bugzilla.kernel.org/attachment.cgi?id=11332&action=view

Hello,

I applied both patches and the kernel panic doesn't happen anymore. I
booted many times and put the box under stress.

Thanks
Sebastian
