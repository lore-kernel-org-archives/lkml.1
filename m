Return-Path: <linux-kernel-owner+w=401wt.eu-S1756394AbYJWVgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbYJWVgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 17:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbYJWVgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 17:36:24 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:61694 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbYJWVgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 17:36:24 -0400
To: apw@shadowen.org
Cc: rdunlap@xenotime.net, jschopp@austin.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: asterisk-slash sequence in quoted string confuses checkpatch.pl
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200810212025.FCC73959.OJVHMOLOFFSQtF@I-love.SAKURA.ne.jp>
	<20081023141437.GE8343@brain>
In-Reply-To: <20081023141437.GE8343@brain>
Message-Id: <200810240636.IDB18266.SJLOFtMFFHQVOO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Fri, 24 Oct 2008 06:36:19 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> We believe that this is fixed in the latest release, and indeed I believe
> you have acked.  But I'll reply again here for completeness.
Yes. You figured out that "Most of these \'s are extraneous" before
you notice this reposting.

Thanks.
