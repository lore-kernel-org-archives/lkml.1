Return-Path: <linux-kernel-owner+w=401wt.eu-S1759257AbXKLNcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257AbXKLNcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 08:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758632AbXKLNcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 08:32:09 -0500
Received: from mail-xgw2.externet.hu ([212.40.96.184]:51415 "EHLO
	mail-xgw2.externet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758357AbXKLNcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 08:32:07 -0500
To: mikulas@artax.karlin.mff.cuni.cz
CC: a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, wfg@mail.ustc.edu.cn
In-reply-to: <Pine.LNX.4.64.0711111926070.19188@artax.karlin.mff.cuni.cz>
	(message from Mikulas Patocka on Sun, 11 Nov 2007 19:29:09 +0100
	(CET))
Subject: Re: Temporary lockup on loopback block device
References: <Pine.LNX.4.64.0711102025440.17691@artax.karlin.mff.cuni.cz> 
 <20071110145444.a6993df1.akpm@linux-foundation.org> <1194735752.5828.1.camel@lappy>
 <Pine.LNX.4.64.0711110135450.18189@artax.karlin.mff.cuni.cz>
 <E1Ir7al-0004Tm-00@dorka.pomaz.szeredi.hu> <Pine.LNX.4.64.0711111926070.19188@artax.karlin.mff.cuni.cz>
Message-Id: <E1IrZOV-0005Q0-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 12 Nov 2007 14:32:03 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On 2.6.23 it could happen even without loopback

Let's focus on this point, because we already know how the lockup
happens _with_ loopback and any other kind of bdi stacking.

Can you describe the setup?  Or better still, can you reproduce it and
post the sysrq-t output?

Thanks,
Miklos
