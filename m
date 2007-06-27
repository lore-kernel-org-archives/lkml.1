Return-Path: <linux-kernel-owner+w=401wt.eu-S1762115AbXF0QBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762115AbXF0QBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 12:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759839AbXF0QBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 12:01:23 -0400
Received: from mondriaan.macroscoop.nl ([82.94.9.2]:1366 "EHLO
	mondriaan.macroscoop.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbXF0QBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 12:01:23 -0400
Message-ID: <468289A1.3080709@macroscoop.nl>
Date: Wed, 27 Jun 2007 18:00:33 +0200
From: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Jesse Barnes <jesse.barnes@intel.com>
CC: Mauro Giachero <mauro.giachero@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Andi Kleen <andi@firstfloor.org>,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
References: <200706251434.43863.jesse.barnes@intel.com> <46823F71.6060200@macroscoop.nl> <da3e877f0706270722x67bb0738x4274b4367e04f0c6@mail.gmail.com> <200706270804.53263.jesse.barnes@intel.com>
In-Reply-To: <200706270804.53263.jesse.barnes@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:

> Yeah, you're right I should use an unsigned format string.  Pim, if you 
> change it to %lu does the printk in your dmesg look better?

Er, no.

**** MTRRs don't cover all of memory, trimmed 18446744073709486080 pages

Thanks,
Pim
