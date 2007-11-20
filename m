Return-Path: <linux-kernel-owner+w=401wt.eu-S1763818AbXKTVje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763818AbXKTVje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758937AbXKTVjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:39:24 -0500
Received: from mailout01.sul.t-online.de ([194.25.134.80]:52344 "EHLO
	mailout01.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758034AbXKTVjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:39:23 -0500
Message-ID: <474353F8.6070804@t-online.de>
Date: Tue, 20 Nov 2007 22:39:04 +0100
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>, mingo@elte.hu
Subject: Re: 2.6.23.8, ondemand scaling governor: "BUG: soft lockup detected
 on CPU#0!"
References: <474227F9.8050909@t-online.de> <924EFEDD5F540B4284297C4DC59F3DEE251A40@orsmsx423.amr.corp.intel.com> <4742980A.60407@t-online.de> <924EFEDD5F540B4284297C4DC59F3DEE251B16@orsmsx423.amr.corp.intel.com>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE251B16@orsmsx423.amr.corp.intel.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: SUg3FEZ1who+7JAKKgKBUO1bdjyhfuCAEozJM8hJnfcaitC5xJNB6DnYN3KxydhwG4
X-TOI-MSGID: 3b8e106e-2969-445f-8d07-95b8b615f3e8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pallipadi, Venkatesh wrote:
> 
> This looks like TSC related issue. Ingo's patch commit id
> a3b13c23f186ecb57204580cc1f2dbe9c284953a
> http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.g
> it;a=commit;h=a3b13c23f186ecb57204580cc1f2dbe9c284953a 
> should help.
> 

Yes, after applying this patch the problem seems to be gone.


Many thanx

Harri

