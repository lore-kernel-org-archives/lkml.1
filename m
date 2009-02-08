Return-Path: <linux-kernel-owner+w=401wt.eu-S1754243AbZBHWqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbZBHWqY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 17:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753522AbZBHWqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 17:46:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753515AbZBHWqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 17:46:13 -0500
Date: Sun, 8 Feb 2009 14:45:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-serial@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] PCI: quirks, don't mark one netmos as class other
Message-Id: <20090208144537.ecf1019b.akpm@linux-foundation.org>
In-Reply-To: <498F558F.109@gmail.com>
References: <1228749555-21363-1-git-send-email-jirislaby@gmail.com>
	<200812091453.32105.jbarnes@virtuousgeek.org>
	<498F558F.109@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Feb 2009 22:58:39 +0100 Jiri Slaby <jirislaby@gmail.com> wrote:

> Jesse Barnes wrote:
> > On Monday, December 08, 2008 7:19 am Jiri Slaby wrote:
> >> Let it as serial, since it doesn't have subdevice in the form of 0x00PS.
> >>
> >> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> >> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> > 
> > Applied to my linux-next branch, thanks.
> 
> Hi, did this get lost by a chance? I don't see it in your -next branch
> anymore. Neither in any other branch nor upstream.
> 
> BTW I got:
> This patch was dropped because it was merged into mainline or a subsystem tree
> from Andrew, so it had to be somewhere, I suppose...

yes, it got lost.  I resurrected it.
