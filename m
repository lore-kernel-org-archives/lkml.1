Return-Path: <linux-kernel-owner+w=401wt.eu-S1752481AbXITUc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbXITUc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 16:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbXITUcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 16:32:19 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:44736 "EHLO
	outbound3-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750858AbXITUcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 16:32:18 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <46F2D695.5070500@am.sony.com>
Date: Thu, 20 Sep 2007 13:22:45 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Rob Landley <rob@landley.net>, linux-tiny@selenic.com,
       linux kernel <linux-kernel@vger.kernel.org>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       Michael Opdenacker <michael@free-electrons.com>
Subject: printk proposal - (was Linux-tiny project revival)
References: <46F1645D.9050406@am.sony.com> <200709201538.43093.rob@landley.net> <20070920195844.GA1805@martell.zuzino.mipt.ru>
In-Reply-To: <20070920195844.GA1805@martell.zuzino.mipt.ru>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Sep 2007 20:23:08.0102 (UTC) FILETIME=[0EA22E60:01C7FBC4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> Given that
> a) there're plenty of printks without any KERN_* bloat,
> b) there're printks that SHOULD NOT have KERN_* bloat,

Just to clarify, which bloat are you concerned about?
I presume source code bloat (but maybe you mean
message size bloat, or object code bloat)?

 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

