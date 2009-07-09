Return-Path: <linux-kernel-owner+w=401wt.eu-S1758557AbZGIC3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557AbZGIC3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 22:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756791AbZGIC3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 22:29:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:57285 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573AbZGIC3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 22:29:03 -0400
Message-ID: <4A5555E1.7000601@kernel.org>
Date: Thu, 09 Jul 2009 11:28:49 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: monstr@monstr.eu
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       microblaze-uclinux@itee.uq.edu.au, Sam Ravnborg <sam@ravnborg.org>,
       Paul Mundt <lethal@linux-sh.org>, Tony Luck <tony.luck@intel.com>,
       Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH percpu 1/2] microblaze: include EXIT_TEXT to _stext
References: <4A546646.70305@kernel.org> <4A5476D2.7040709@monstr.eu>
In-Reply-To: <4A5476D2.7040709@monstr.eu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 09 Jul 2009 02:28:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Simek wrote:
>> Michal, I added the commit messaeg and SOB.  If you don't like it
>> please let me know.
> 
> It is ok. I rechecked it and works.

Thanks.  Patches committed to percpu#for-next.

-- 
tejun
