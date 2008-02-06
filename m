Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbYBFSpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbYBFSpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 13:45:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbYBFSow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 13:44:52 -0500
Received: from ara.aytolacoruna.es ([91.117.124.165]:51878 "EHLO
	mx.aytolacoruna.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbYBFSov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 13:44:51 -0500
Date: Wed, 6 Feb 2008 19:44:47 +0100
From: Santiago Garcia Mantinan <manty@manty.net>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: uli526x doesn't get link if no link when interface is set up
Message-ID: <20080206184447.GA15443@dis.manty.net>
References: <20080202145638.GA5871@dis.manty.net> <20080206061507.GA22107@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206061507.GA22107@colo.lackof.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is this perhaps the same problem as described here?
>     http://bugzilla.kernel.org/show_bug.cgi?id=5839

Seems right.

> If you think it is, could you add (just cut/paste)
> you email to that bug for me?

Done

> Could you also try the patch I attached to that bug report?
> If it works for you, we can both pester Kyle McMartin to
> push it upstream. ;)

Yes, I have tried it and seems to solve the problem for me as well. I'd
agree to push it.

Regards...
-- 
Manty/BestiaTester -> http://manty.net
