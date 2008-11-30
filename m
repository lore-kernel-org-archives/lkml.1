Return-Path: <linux-kernel-owner+w=401wt.eu-S1755296AbYK3NI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbYK3NI1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 08:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbYK3NIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 08:08:16 -0500
Received: from styx.suse.cz ([82.119.242.94]:41033 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751384AbYK3NIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 08:08:15 -0500
Date: Sun, 30 Nov 2008 14:08:13 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
cc: Hannes Eder <hannes@hanneseder.net>,
       Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [PATCH] rtc-ds1511: fix sparse warning
In-Reply-To: <20081130013949.280ae5c0@i1501.lan.towertech.it>
Message-ID: <alpine.LNX.1.10.0811301407330.15220@jikos.suse.cz>
References: <493049fa.06a1660a.3655.ffffab3c@mx.google.com> <20081130013949.280ae5c0@i1501.lan.towertech.it>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Nov 2008, Alessandro Zummo wrote:

> > Fix this sparse warning:
> > 
> >   drivers/rtc/rtc-ds1511.c:634:2: warning: returning void-valued expression
> > 
> > Signed-off-by: Hannes Eder <hannes@hanneseder.net>
>  Acked-by: Alessandro Zummo <a.zummo@towertech.it>

Applied to trivial patches tree. If anyone has already merged this through 
another subsystem tree, please let me know.

Thanks,

-- 
Jiri Kosina
SUSE Labs
