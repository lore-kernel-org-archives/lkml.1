Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933819Ab0BETGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 14:06:32 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:50756 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933733Ab0BETGa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 14:06:30 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=lK9Zo1qIsI9qo5S8vRjTIkQu5EZNOXfvFz/cYfl+VYjC974VulxOkLgQju+ZDYR2Yz69GmXOZ8fWtZWMcCNutr98wr97x/o5Pb628kTZv71ym/aNSPP2tmkgsE8Rj/G9;
Date: Fri, 5 Feb 2010 11:05:39 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Eric Anholt" <eric@anholt.net>, "Matthew Garrett" <mjg@redhat.com>,
       "Toralf =?UTF-8?B?RsO2cnN0ZXI=?=" <toralf.foerster@gmx.de>
Subject: Re: [Bug #15100] X11 is black after resume from s2ram if my T400
 was previous in docking station before
Message-ID: <20100205110539.4df65968@jbarnes-piketon>
In-Reply-To: <de962C6zBxL.A.BVE.KFiZLB@chimera>
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera>
	<de962C6zBxL.A.BVE.KFiZLB@chimera>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  1 Feb 2010 01:43:20 +0100 (CET)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still
> should be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15100
> Subject		: X11 is black after resume from s2ram if my
> T400 was previous in docking station before Submitter	: Toralf
> Förster <toralf.foerster@gmx.de> Date		: 2010-01-21
> 08:56 (11 days old) First-Bad-Commit:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c1c7af60892070e4b82ad63bbfb95ae745056de0

Just updated the bug, looks like another LID status related bug.

-- 
Jesse Barnes, Intel Open Source Technology Center
