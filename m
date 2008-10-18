Return-Path: <linux-kernel-owner+w=401wt.eu-S1751703AbYJRWwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbYJRWwW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 18:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750973AbYJRWwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 18:52:16 -0400
Received: from styx.suse.cz ([82.119.242.94]:60146 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750938AbYJRWwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 18:52:16 -0400
Date: Sun, 19 Oct 2008 00:52:14 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jirislaby@gmail.com>
cc: Steven Noonan <steven@uplinklabs.net>,
       Justin Mattock <justinmattock@gmail.com>,
       Sven Anders <anders@anduras.de>, linux-kernel@vger.kernel.org
Subject: Re: appletouch regression
In-Reply-To: <1224359819-15152-1-git-send-email-jirislaby@gmail.com>
Message-ID: <alpine.LNX.1.10.0810190050410.27479@jikos.suse.cz>
References: <f488382f0810181134h24ed5da8lc12e62816436bb5@mail.gmail.com> <1224359819-15152-1-git-send-email-jirislaby@gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Oct 2008, Jiri Slaby wrote:

> Yeah, I see the problem. The device is grabbed by the hid bus and not
> released even if apple driver says ENODEV (this is expected behaviour
> and noted in the driver).
> Could you try this patch? (Not ready for merge, it needs to be cleaned
> up.)

Will you please send me polished patch with changelog and Signed-off-by, 
so that I can queue it in my upstream-fixes branch that will go to Linus 
shortly?

Thanks,

-- 
Jiri Kosina
SUSE Labs
