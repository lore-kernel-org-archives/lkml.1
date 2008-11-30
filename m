Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbYK3NJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbYK3NJU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 08:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbYK3NJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 08:09:07 -0500
Received: from styx.suse.cz ([82.119.242.94]:41060 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751273AbYK3NJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 08:09:07 -0500
Date: Sun, 30 Nov 2008 14:09:06 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
cc: Hannes Eder <hannes@hanneseder.net>, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [PATCH] rtc-stk17ta8: fix sparse warning
In-Reply-To: <20081130013931.1b48f892@i1501.lan.towertech.it>
Message-ID: <alpine.LNX.1.10.0811301408180.15220@jikos.suse.cz>
References: <49304ffd.09a1660a.30b3.ffffc7a7@mx.google.com> <20081130013931.1b48f892@i1501.lan.towertech.it>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Nov 2008, Alessandro Zummo wrote:

> > Fix this sparse warning:
> > 
> >   drivers/rtc/rtc-stk17ta8.c:403:2: warning: returning void-valued expression
> > 
> > Signed-off-by: Hannes Eder <hannes@hanneseder.net>
>  Acked-by: Alessandro Zummo <a.zummo@towertech.it>

Thanks. The same as for rtc-ds1511 patch -- I have queued it in trivial 
tree, if anyone has taken it through another tree, please let me know.

-- 
Jiri Kosina
SUSE Labs
