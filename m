Return-Path: <linux-kernel-owner+w=401wt.eu-S1762200AbYARPYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762200AbYARPYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 10:24:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759986AbYARPYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 10:24:44 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:57102 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762104AbYARPYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 10:24:43 -0500
To: apw@shadowen.org, rdunlap@xenotime.net, jschopp@austin.ibm.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24-rc8-mm1] checkpatch.pl -- Handle backslashes within quoted string.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200801182221.CID64509.JSMOFHtOFLVQFO@I-love.SAKURA.ne.jp>
In-Reply-To: <200801182221.CID64509.JSMOFHtOFLVQFO@I-love.SAKURA.ne.jp>
Message-Id: <200801190024.GBG57380.JSMFHVOOLtOFFQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 19 Jan 2008 00:24:41 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tetsuo Handa wrote:
> checkpatch.pl was unable to handle \\ within quoted string.

Sorry, I didn't know checkpatch 0.13 is available.
