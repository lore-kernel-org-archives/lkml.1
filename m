Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbYHYNkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbYHYNkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 09:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755914AbYHYNjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 09:39:39 -0400
Received: from smtp.nokia.com ([192.100.122.233]:33422 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099AbYHYNji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 09:39:38 -0400
Date: Mon, 25 Aug 2008 16:39:13 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext pHilipp Zabel <philipp.zabel@gmail.com>
Cc: Felipe Balbi <me@felipebalbi.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, david-b@pacbell.net, tony@atomide.com
Subject: Re: [PATCH 2/4] USB: OTG: Make otg_get_transceiver() and
	otg_set_transceiver() generic
Message-ID: <20080825133913.GJ20450@gandalf.research.nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1200753446-9378-1-git-send-email-me@felipebalbi.com> <1200753446-9378-2-git-send-email-me@felipebalbi.com> <1200753446-9378-3-git-send-email-me@felipebalbi.com> <74d0deb30808250635p670d7fd8vdf75ea5111ad0077@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74d0deb30808250635p670d7fd8vdf75ea5111ad0077@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 25 Aug 2008 13:39:13.0031 (UTC) FILETIME=[F5DAD170:01C906B7]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 03:35:06PM +0200, ext pHilipp Zabel wrote:
> what is the status of this patch? I guess moving
> otg_get/set_transceiver into usb core like this (and adding
> otg_put_transceiver) is better than duplicating this code for PXA and
> other architectures?

Yeah, this was never applied. I'll try to format the patches again, but
it'll take a while since I'm really busy with work.

-- 
balbi
