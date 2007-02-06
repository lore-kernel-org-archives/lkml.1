Return-Path: <linux-kernel-owner+w=401wt.eu-S933025AbXBFSgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025AbXBFSgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 13:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933153AbXBFSgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 13:36:20 -0500
Received: from www.osadl.org ([213.239.205.134]:49852 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933025AbXBFSgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 13:36:20 -0500
Subject: Re: 2.6.20-rc6-mm3
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Walker <dwalker@mvista.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <1170777802.9781.353.camel@imap.mvista.com>
References: <20070129204528.eb8d695e.akpm@osdl.org>
	 <1170777802.9781.353.camel@imap.mvista.com>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 19:36:32 +0100
Message-Id: <1170786992.3785.0.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 08:03 -0800, Daniel Walker wrote:
> It appears there a problem with the /proc/interrupts entry for
> "timer" .. It doesn't increment anymore .. This problem exists in the
> -rt tree also .. I haven't done a bisect , but I'm assuming this is HRT
> related ..

And why should it increment ? Is there a rule that it has to ?

	tglx



