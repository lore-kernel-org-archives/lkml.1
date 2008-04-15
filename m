Return-Path: <linux-kernel-owner+w=401wt.eu-S1759539AbYDOQIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759539AbYDOQIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 12:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbYDOQIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 12:08:31 -0400
Received: from pat.uio.no ([129.240.10.15]:42660 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbYDOQIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 12:08:30 -0400
Subject: Re: User space automounter problems after upgrade to 2.6.25-rc9
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Martin Knoblauch <spamtrap@knobisoft.de>
Cc: linux-kernel@vger.kernel.org, am-utils <am-utils@am-utils.org>
In-Reply-To: <914095.44950.qm@web32604.mail.mud.yahoo.com>
References: <914095.44950.qm@web32604.mail.mud.yahoo.com>
Content-Type: text/plain
Date: Tue, 15 Apr 2008 12:08:27 -0400
Message-Id: <1208275707.10759.7.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: 2E9814C0110088373DB66A50EA8CEFAB137900D3
X-UiO-SR-test: 47D71AC88D2F6EE3B5A712C01F3097D345CA62E0
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 127 total 7902759 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-04-15 at 06:58 -0700, Martin Knoblauch wrote:

>  Not sure what kind of side effects that will have. Probably better to stay at 2.6.24 and wait for a fix in am-utils.

2.6.24 has exactly the same problem. It is just that the kernel will
report it much later (essentially the first time that you try to lock a
file).

Trond

