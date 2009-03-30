Return-Path: <linux-kernel-owner+w=401wt.eu-S1760447AbZC3WIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760447AbZC3WIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 18:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760730AbZC3WIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 18:08:04 -0400
Received: from mga05.intel.com ([192.55.52.89]:26380 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759169AbZC3WID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 18:08:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,448,1233561600"; 
   d="scan'208";a="677293975"
Message-ID: <49D142AC.8090701@linux.intel.com>
Date: Mon, 30 Mar 2009 15:07:40 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Hans-Peter Jansen <hpj@urpla.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <1238168777.5969.18.camel@marge.simson.net> <alpine.LFD.2.00.0903270852070.3994@localhost.localdomain> <200903310000.11522.hpj@urpla.net>
In-Reply-To: <200903310000.11522.hpj@urpla.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans-Peter Jansen wrote:
> Am Freitag, 27. März 2009 schrieb Linus Torvalds:
> 
> I always wonder, why Arjan does not intervene for his kerneloops.org 
> project, since your approach opens a window of uncertainty during the merge 
> window when simply using git as an efficient fetch tool.

I would *love* it if Linus would, as first commit mark his tree as "-git0"
(as per snapshots) or "-rc0". So that I can split the "final" versus
"merge window" oopses.



