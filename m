Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbYAVSpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbYAVSpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 13:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbYAVSpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 13:45:12 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:3014 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbYAVSpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 13:45:11 -0500
Date: Tue, 22 Jan 2008 18:44:21 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: rdunlap@xenotime.net, jschopp@austin.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24-rc8-mm1] checkpatch.pl -- Handle backslashes within quoted string.
Message-ID: <20080122184421.GC5941@shadowen.org>
References: <200801182221.CID64509.JSMOFHtOFLVQFO@I-love.SAKURA.ne.jp> <200801190024.GBG57380.JSMFHVOOLtOFFQ@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801190024.GBG57380.JSMFHVOOLtOFFQ@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2008 at 12:24:41AM +0900, Tetsuo Handa wrote:
> 
> Tetsuo Handa wrote:
> > checkpatch.pl was unable to handle \\ within quoted string.
> 
> Sorry, I didn't know checkpatch 0.13 is available.

No problem.  Thanks for trying to fix it.

:)

-apw
