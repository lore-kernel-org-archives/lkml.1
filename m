Return-Path: <linux-kernel-owner+w=401wt.eu-S1754970AbZBEWNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbZBEWNM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 17:13:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbZBEWM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 17:12:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752678AbZBEWM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 17:12:56 -0500
Date: Thu, 5 Feb 2009 14:12:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, vapier.adi@gmail.com, cooloney@kernel.org
Subject: Re: [PATCH 1/5] Blackfin SPI Driver: use bfin_spi_ prefix on all
 functions
Message-Id: <20090205141245.2945141e.akpm@linux-foundation.org>
In-Reply-To: <1233828453-13311-2-git-send-email-cooloney@kernel.org>
References: <1233828453-13311-1-git-send-email-cooloney@kernel.org>
	<1233828453-13311-2-git-send-email-cooloney@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  5 Feb 2009 18:07:29 +0800
Bryan Wu <cooloney@kernel.org> wrote:

> Do this because when things crash, we get simple names like "setup" and
> "start_queue" which is pretty difficult to trace back to the real thing:
> the spi driver
> 

As usual, the driver core guys have gone trompling all over other people's code
and your patch doesn't apply to linux-next.

11 out of 61 hunks FAILED -- saving rejects to file drivers/spi/spi_bfin5xx.c.rej
