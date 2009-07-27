Return-Path: <linux-kernel-owner+w=401wt.eu-S1752199AbZG0RK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbZG0RK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 13:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750718AbZG0RK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 13:10:57 -0400
Received: from outbound-mail-36.bluehost.com ([69.89.20.190]:49438 "HELO
	outbound-mail-36.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750756AbZG0RK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 13:10:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=KyxBCJeO19txh0Jrd1HE3085+SUXGwcyg7afC7Bz1fyC4i8f13PvUi62F3sbs5wqYx2Ar9fQxBO7s1OnoZBeiIzU0Na+a2ZgHS0PTlfzNOxhJ5MA0QPiQf8sLbbpv/IG;
Date: Mon, 27 Jul 2009 10:10:53 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Diego Calleja" <diegocg@gmail.com>,
       "Shaohua Li" <shaohua.li@intel.com>
Subject: Re: [Bug #13840] KMS oops on 945G system
Message-ID: <20090727101053.5a76bb08@jbarnes-g45>
In-Reply-To: <3zAHs5O6maO.A.muB.FHObKB@chimera>
References: <Jya1GruKQpD.A.16.2GObKB@chimera>
	<3zAHs5O6maO.A.muB.FHObKB@chimera>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Jul 2009 22:28:29 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13840
> Subject		: KMS oops on 945G system
> Submitter	: Diego Calleja <diegocg@gmail.com>
> Date		: 2009-07-21 20:50 (6 days old)
> First-Bad-Commit:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7662c8bd6545c12ac7b2b39e4554c3ba34789c50
> References	:
> http://marc.info/?l=linux-kernel&m=124820945815030&w=4
> Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>
> Patch		:
> http://git.kernel.org/?p=linux/kernel/git/anholt/drm-intel.git;a=commit;h=dff33cfcefa31c30b72c57f44586754ea9e8f3e2

There's a fix for this one queued in Eric's tree.

-- 
Jesse Barnes, Intel Open Source Technology Center
