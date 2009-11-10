Return-Path: <linux-kernel-owner+w=401wt.eu-S1758490AbZKJWyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490AbZKJWyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbZKJWya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:54:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751214AbZKJWya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:54:30 -0500
Date: Tue, 10 Nov 2009 14:54:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Fertser <fercerpav@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
       rtc-linux@googlegroups.com
Subject: Re: [PATCH 0/3] rtc: pcf50633 fixes (is rtc maintainer around?)
Message-Id: <20091110145429.46150d57.akpm@linux-foundation.org>
In-Reply-To: <1257371717-547-1-git-send-email-fercerpav@gmail.com>
References: <1257371717-547-1-git-send-email-fercerpav@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  5 Nov 2009 00:55:14 +0300
Paul Fertser <fercerpav@gmail.com> wrote:

> [PATCH 1/3] rtc: pcf50633: Fix month off-by-one error
> [PATCH 2/3] rtc: pcf50633: consider alrm->enable in pcf50633_rtc_set_alarm
> [PATCH 3/3] rtc: pcf50633: manage RTC alarm "pending" flag

I queued 1 and 2 for 2.6.32 (but not 2.6.31.x or earlier).
I queued 3 for 2.6.33.

If that was inappropriate then please let me know, with the reasons.
