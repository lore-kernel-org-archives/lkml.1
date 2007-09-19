Return-Path: <linux-kernel-owner+w=401wt.eu-S1761844AbXISSD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761844AbXISSD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 14:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbXISSDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 14:03:49 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:60829 "EHLO
	outbound3-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751943AbXISSDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 14:03:48 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <46F1645D.9050406@am.sony.com>
Date: Wed, 19 Sep 2007 11:03:09 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>,
       linux-tiny <Linux-tiny@selenic.com>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>
CC: Michael Opdenacker <michael@free-electrons.com>,
       john cooper <john.cooper@third-harmonic.com>,
       Matt Mackall <mpm@selenic.com>
Subject: [Announce] Linux-tiny project revival
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Sep 2007 18:03:36.0714 (UTC) FILETIME=[667BFEA0:01C7FAE7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Recently, the CE Linux forum has been working to revive the
Linux-tiny project.  At OLS, I asked for interested parties
to volunteer to become the new maintainer for the Linux-tiny patchset.

A few candidates came forward, but eventually Michael Opdenacker
was selected as the new primary maintainer.  A few other
people, including John Cooper of Wind River and myself
are working to support this effort.

Recently, many of the Linux-tiny patches have been brought up-to-date
and are now available for use with a 2.6.22 kernel.  The intent
is to test these, and begin mainlining the most effective sub-patches,
in the next few months.

Some automated testing has already been set up, with some
preliminary results published at a CELF conference in Japan.
(See the linux-tiny page below for a link to the presentation.)
Hopefully, results publishing will also be automated soon.

We encourage anyone with interest in this project to get involved.
If you have ideas how to reduce the static or dynamic memory footprint
of Linux, or, even better, patches for this, please let us know about
them.

Please see http://elinux.org/Linux_Tiny

A related document: http://elinux.org/Kernel_Size_Tuning_Guide
is undergoing an update this week.

Thanks,
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

