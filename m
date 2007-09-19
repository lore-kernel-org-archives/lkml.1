Return-Path: <linux-kernel-owner+w=401wt.eu-S1755154AbXISTcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbXISTcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 15:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbXISTbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 15:31:51 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:56562 "EHLO
	outbound1-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752394AbXISTbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 15:31:50 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <46F17900.1020908@am.sony.com>
Date: Wed, 19 Sep 2007 12:31:12 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux kernel <linux-kernel@vger.kernel.org>,
       linux-tiny <Linux-tiny@selenic.com>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       Michael Opdenacker <michael@free-electrons.com>
Subject: Re: [Announce] Linux-tiny project revival
References: <46F1645D.9050406@am.sony.com> <43e72e890709191147h63d4d780l7091e7baefc8345d@mail.gmail.com>
In-Reply-To: <43e72e890709191147h63d4d780l7091e7baefc8345d@mail.gmail.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Sep 2007 19:31:39.0245 (UTC) FILETIME=[B31E41D0:01C7FAF3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Luis R. Rodriguez wrote:
> Will there be a separate git for testing?

Right now we're publishing a quilt-able tarball.
Instructions for applying this are on the
http://elinux.org/Linux_Tiny page.

Note that some broken patches are kept around
in the patches/tiny directory, but commented
out in the series file, in case someone
wants to un-bitrot them.

> Is the idea to still keep
> moving patches upstream?

Yes, very much so.  These patches have been
showing up in CE products, and this is part
of an overall effort to dust them off, test
them, and move them upstream.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

