Return-Path: <linux-kernel-owner+w=401wt.eu-S1031284AbXDQWMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031284AbXDQWMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 18:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031288AbXDQWMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 18:12:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34660 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031284AbXDQWMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 18:12:47 -0400
Date: Wed, 18 Apr 2007 00:12:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Karl MacMillan <kmacmill@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Casey Schaufler <casey@schaufler-ca.com>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: AppArmor FAQ
Message-ID: <20070417221245.GD11944@one.firstfloor.org>
References: <20070417181016.GA10903@one.firstfloor.org> <657751.18080.qm@web36614.mail.mud.yahoo.com> <20070417211653.GB11944@one.firstfloor.org> <1176846088.5946.62.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1176846088.5946.62.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The vast majority of applications are not
> modified to be SELinux aware - only a small handful of security aware
> applications are modified. 

All applications that can edit /etc/resolv.conf? That's nearly 
everything. You yourself gave the example; I'm not making anything up.

-Andi (sensing a loop in the thread -- things that already have been
discussed come back from the dead.)

P.S.: If you want to loop further please drop me from cc.

