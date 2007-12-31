Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147AbXLaPZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbXLaPZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 10:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbXLaPZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 10:25:49 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:57951 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbXLaPZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 10:25:48 -0500
To: serue@us.ibm.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: TOMOYO Linux Security Goal
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20071227145431.GB5161@sergelap.austin.ibm.com>
	<200712282332.EGC57888.OFFQHJOLVSMtFO@I-love.SAKURA.ne.jp>
	<20071228151221.GA12548@sergelap.austin.ibm.com>
	<200712291243.HFE05726.MFOJOVLQFFOtSH@I-love.SAKURA.ne.jp>
	<20071231151712.GA28624@sergelap.austin.ibm.com>
In-Reply-To: <20071231151712.GA28624@sergelap.austin.ibm.com>
Message-Id: <200801010025.DDC48911.SOLOMQFFHVFtOJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Tue, 1 Jan 2008 00:25:44 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Serge E. Hallyn wrote:
> > Does a process get different mount trees by just calling clone() or unshare()?
> > My understanding is that clone() or unshare() disables propergation of
> > mount tree changes when somebody calls mount() or umount() or pivot_root().
> 
> Yes, with further propagation rules possible.
> 
Excuse me. To which statement did you say "yes"?

Does clone() or unshare() change visible directories without
calling following mount()/umount()/pivot_root()?

Regards.
