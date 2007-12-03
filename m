Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbXLCLds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbXLCLds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 06:33:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752961AbXLCLdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 06:33:42 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:53240 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880AbXLCLdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 06:33:41 -0500
To: vegard.nossum@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG 2.6.24-rc3-git6] SLUB's ksize() fails for size > 2048.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200712021939.HHH18792.FLQSOOtFOFJVHM@I-love.SAKURA.ne.jp>
	<19f34abd0712020830y4825691atdfc9dac07ce4cb35@mail.gmail.com>
	<19f34abd0712020843m1dccfa3bu38388e1a53b05fc@mail.gmail.com>
In-Reply-To: <19f34abd0712020843m1dccfa3bu38388e1a53b05fc@mail.gmail.com>
Message-Id: <200712032033.DCF04184.LHJVOFtOFMFQSO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Mon, 3 Dec 2007 20:33:38 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Vegard Nossum wrote:
> That didn't work. I guess that's what you get for no testing ;-) After
> some more investigations, it seems that this is the correct way to fix
> it (and tested!):
It worked in my environment too.

Please apply to 2.6.24-rc3-git6's tree.

Thank you.
