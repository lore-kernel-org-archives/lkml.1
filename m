Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab0BPMaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 07:30:55 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49780 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752054Ab0BPMay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 07:30:54 -0500
Date: Tue, 16 Feb 2010 12:28:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Alexander Gordeev <lasaine@lvk.cs.msu.su>
Subject: Re: LinuxPPS new functionalities
Message-ID: <20100216122855.1a9896fb@lxorguk.ukuu.org.uk>
In-Reply-To: <1266313885-1195-1-git-send-email-giometti@linux.it>
References: <1266313885-1195-1-git-send-email-giometti@linux.it>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010 10:51:17 +0100
Rodolfo Giometti <giometti@linux.it> wrote:

> This patchset adds several PPS functionalities.
> 
> All patches have a specific comment but I prefer say something more:
> 
> * Patches 01-02 are just documentation about PPS support.
> 
> * Patch 03 adds PPS client support skeleton.
> 
> * Patches 04-06 add generic PPS serial support (with specific
>   modifications requested by Alan Cox).

Thanks - the serial/tty stuff is much much cleaner in this patch set.

