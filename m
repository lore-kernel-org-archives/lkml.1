Return-Path: <linux-kernel-owner+w=401wt.eu-S1759412AbXHUGpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412AbXHUGpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 02:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154AbXHUGpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 02:45:33 -0400
Received: from mx1.ciphirelabs.net ([217.72.114.64]:40354 "EHLO
	mx.dmz.ciphirelabs.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033AbXHUGpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 02:45:32 -0400
From: "Andreas Jellinghaus [c]" <aj@ciphirelabs.com>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] why was MODALIAS removed from usb kernel events? [u]
Date: Tue, 21 Aug 2007 08:45:05 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
References: <Pine.LNX.4.44L0.0708201158110.3626-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0708201158110.3626-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="ansi_x3.4-1968"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708210845.05385.aj@ciphirelabs.com>
X-Ciphire-Security: plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 20. August 2007 schrieb Alan Stern:
> I could, but I don't know whether any of this would be accepted for
> 2.6.22.stable.  It might not be too late to get into 2.6.23...

even without it is a first step. I hope it gets accepted into both,
as 2.6.22 broke kernel<->user space interfaces and those should
never change (or only after a long time with announcement, time
for switching to a new one etc).

Thanks for your work!

Regards, Andreas
