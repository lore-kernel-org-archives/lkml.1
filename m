Return-Path: <linux-kernel-owner+w=401wt.eu-S1762549AbYEGPX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762549AbYEGPX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 11:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757883AbYEGPXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 11:23:12 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:62677 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757664AbYEGPXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 11:23:10 -0400
To: rmk+lkml@arm.linux.org.uk
Cc: alan@lxorguk.ukuu.org.uk, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] NULL pointer dereference in uart_write_room().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <261636618@web.de>
	<200805022300.GIB30385.FJOVHQSMFtOOFL@I-love.SAKURA.ne.jp>
	<200805041716.DDG43279.JOSMHVFOFFQLOt@I-love.SAKURA.ne.jp>
	<20080505113055.5284052e@core>
	<20080506212328.GA17929@flint.arm.linux.org.uk>
In-Reply-To: <20080506212328.GA17929@flint.arm.linux.org.uk>
Message-Id: <200805080023.IHH34204.tQMOFJFVFHOLOS@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Thu, 8 May 2008 00:23:07 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Russell King wrote:
> Is the rest of the report available somewhere?

Yes.

First report:  http://lkml.org/lkml/2008/4/22/42
Second report: http://lkml.org/lkml/2008/5/2/22
Third report:  http://lkml.org/lkml/2008/5/4/34

Regards.
