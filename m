Return-Path: <linux-kernel-owner+w=401wt.eu-S1763582AbXHAAuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763582AbXHAAuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 20:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbXHAAt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 20:49:58 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60324 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752080AbXHAAt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 20:49:57 -0400
Date: Tue, 31 Jul 2007 17:49:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Neal Becker <ndbecker2@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: garmin_gps not working with etrex vista cx
Message-Id: <20070731174944.8a5addee.akpm@linux-foundation.org>
In-Reply-To: <f8nht6$pfl$1@sea.gmane.org>
References: <f8nht6$pfl$1@sea.gmane.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 10:44:39 -0400 Neal Becker <ndbecker2@gmail.com> wrote:

> I can't seem to transfer routes to my garmin etrex vista cx.  I get
> (repeatably) truncated routes, and:
> Jul 31 07:19:07 nbecker4 kernel: usb 2-2: reset full speed USB device using
> ohci_hcd and address 3
> Jul 31 07:24:05 nbecker4 kernel: usb 2-2: reset full speed USB device using
> ohci_hcd and address 3
> Jul 31 07:26:04 nbecker4 last message repeated 3 times
> ...
> 
> The problem must be the kernel driver, because I can d/l the same file using
> windoze without problems.
> 
> Jul 31 07:13:18 nbecker4 kernel: garmin_gps 2-2:1.0: Garmin GPS usb/tty
> converter detected
> 

Which kernel version are you using?

Did any earlier kernel version work correctly?

(Use verizon vznavigator instead - it's kewl ;))
