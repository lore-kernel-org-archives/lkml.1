Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbZKBMUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbZKBMUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 07:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754488AbZKBMUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 07:20:19 -0500
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:36165
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754452AbZKBMUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 07:20:18 -0500
Date: Mon, 2 Nov 2009 13:20:11 +0100
From: Michael Guntsche <mike@it-loops.com>
To: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org
Subject: Re: Page alloc problems with 2.6.32-rc kernels
Message-ID: <20091102122010.GA5552@gibson.comsick.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Missed the CC's

Good morning,

> I have the server running with all with patches applied and it runs
> without any issues. Since adding patch5 seems to make a difference I
> will revert 1-4 and only apply patch 5 to see if it work too. I will
> report back as soon as I have news.

Current status of my tests here. With only patch 5 applied (the revert)
I am not able to reproduce the problem. Reading through the ml archives
I noticed that this revert is somewhat controversial since it seems to
fix other bugs. Is it possible that reverting those fixes just hide the bug I am seeing instead of fixing it?

Kind regards,
Michael

