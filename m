Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbYL3Pwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbYL3Pwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 10:52:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbYL3PwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 10:52:24 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:27594 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbYL3PwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 10:52:23 -0500
Date: Tue, 30 Dec 2008 16:52:15 +0100
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [2.6.28] NULL pointer dereference at get_stats()
Message-ID: <20081230155215.GA31531@gambetta>
References: <200812302153.ECH86976.MFLOQFJHtSOOFV@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812302153.ECH86976.MFLOQFJHtSOOFV@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
> 
> This bug resembles the one I reported at http://lkml.org/lkml/2008/11/28/99 .

Does adding maxcpus=0 to the boot parameters solve the problem? Stephen
suspected a per-cpu variable related problem.

Regards,
Frederik
