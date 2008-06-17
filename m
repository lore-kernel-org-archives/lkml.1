Return-Path: <linux-kernel-owner+w=401wt.eu-S1757197AbYFQUHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbYFQUHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 16:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbYFQUHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 16:07:11 -0400
Received: from mail-wa4.bigfish.com ([216.32.181.111]:60109 "EHLO
	mail14-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752147AbYFQUHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 16:07:10 -0400
X-BigFish: VPS-4(zz98dR1315mzz10d3izzz2fh6bh)
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <4858193F.6080607@am.sony.com>
Date: Tue, 17 Jun 2008 13:06:23 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jim Freeman <jfree@sovereign.org>
CC: J??rn Engel <joern@logfs.org>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Recommendation for activating a deferred module init in the kernel
References: <48580116.9070504@am.sony.com> <20080617190750.GA31224@logfs.org> <20080617192248.GH11921@sovereign.org>
In-Reply-To: <20080617192248.GH11921@sovereign.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jun 2008 20:06:56.0845 (UTC) FILETIME=[B1AA5FD0:01C8D0B5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Freeman wrote:
> Run modprobe?  Have it do just the _init bits without a load/link
> of the actual module text?

Interesting...  Maybe I could overload sys_init_module().  I'll take
a look at this.
  -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

