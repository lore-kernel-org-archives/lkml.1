Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbXISVde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbXISVde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 17:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbXISVd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 17:33:26 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:30635 "EHLO
	outbound3-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387AbXISVd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 17:33:26 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <46F194D5.9050800@am.sony.com>
Date: Wed, 19 Sep 2007 14:29:57 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Andi Kleen <andi@firstfloor.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-tiny <Linux-tiny@selenic.com>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       Michael Opdenacker <michael@free-electrons.com>,
       john cooper <john.cooper@third-harmonic.com>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [Announce] Linux-tiny project revival
References: <46F1645D.9050406@am.sony.com> <p73fy1av4jc.fsf@bingen.suse.de>            <46F17B54.6070106@am.sony.com> <12631.1190234722@turing-police.cc.vt.edu>
In-Reply-To: <12631.1190234722@turing-police.cc.vt.edu>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Sep 2007 21:30:25.0074 (UTC) FILETIME=[4A717920:01C7FB04]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Wed, 19 Sep 2007 12:41:08 PDT, Tim Bird said:
>> The patchkit gives a place for things to live while they are out
>> of mainline, and still have multiple people use and work on them.
> 
> Is anybody working on testing that the patchkit "does no harm" for bigger
> boxes (laptops, desktops, servers)? 
Not to my knowledge.  Most of the things it provides are
only activated by config options.  So my sense is that just
applying the patches should be harmless.  But we'll need some
runtime testing to see what affect some of these have on
big iron.

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

