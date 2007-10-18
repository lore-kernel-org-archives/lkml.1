Return-Path: <linux-kernel-owner+w=401wt.eu-S933374AbXJRQC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933374AbXJRQC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 12:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757398AbXJRQCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 12:02:49 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:13742 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756464AbXJRQCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 12:02:48 -0400
Message-ID: <47178308.9030903@panasas.com>
Date: Thu, 18 Oct 2007 18:00:08 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use relative symbolic links for bzImge in x86 ARCHs
References: <4715F2E5.6000104@panasas.com> <20071017191633.GB11837@uranus.ravnborg.org> <47177C28.5010609@panasas.com> <20071018155459.GA20698@uranus.ravnborg.org>
In-Reply-To: <20071018155459.GA20698@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Oct 2007 16:00:09.0284 (UTC) FILETIME=[F54AA040:01C8119F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18 2007 at 17:54 +0200, Sam Ravnborg <sam@ravnborg.org> wrote:
> Hi Benny.
> 
>> use relative paths in the symlink to bzImage
>> to make it NFS export safe.
>>
>> Signed-off-by: Benny Halevy <bhalevy@panasas.com>
> 
> Your patch looks perfect - but you are a few hours too late.
> 
> See:
> http://git.kernel.org/?p=linux/kernel/git/tglx/linux-2.6-x86.git;a=commit;h=a0075a509bd955ff6fc6e071efabb926e14bf19c
> 
> This is in the mm branch awaiting some more testing
> before Thomas push it to Linus.
> 
> 	Sam
NP,
as long as it's fixed I'm happy

Tested-by: Boaz Harrosh <bharrosh@panasas.com>

Thanks
