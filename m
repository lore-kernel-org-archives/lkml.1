Return-Path: <linux-kernel-owner+w=401wt.eu-S1752565AbXLXPay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbXLXPay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 10:30:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbXLXPaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 10:30:46 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48425 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbXLXPaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 10:30:46 -0500
Date: Mon, 24 Dec 2007 16:31:52 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Julia Lawall <julia@diku.dk>
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 7/38] arch/x86/ia32: Use time_before, time_before_eq, etc.
Message-ID: <20071224153152.GA21971@one.firstfloor.org>
References: <Pine.LNX.4.64.0712241522410.23999@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712241522410.23999@ask.diku.dk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 24, 2007 at 03:23:19PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The functions time_before, time_before_eq, time_after, and time_after_eq
> are more robust for comparing jiffies against other values.

The old code was actually correct I think, but the change is ok for me.

-Andi
