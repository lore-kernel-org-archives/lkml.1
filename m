Return-Path: <linux-kernel-owner+w=401wt.eu-S1752773AbZFXGRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbZFXGRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 02:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbZFXGRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 02:17:44 -0400
Received: from mga06.intel.com ([134.134.136.21]:20141 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751201AbZFXGRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 02:17:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,281,1243839600"; 
   d="scan'208";a="527320024"
Message-ID: <4A41C4E2.5080206@linux.intel.com>
Date: Wed, 24 Jun 2009 08:17:06 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.30-git(16 and 17) system hangs after resume from suspend
 to 	disk, mce related?
References: <8db1092f0906211002y2b391212ve2902fc3a6517586@mail.gmail.com>	 <4A3E7F38.7030300@linux.intel.com> <8db1092f0906211313x73ac9340n9af5775b56cfd189@mail.gmail.com> <4A3EE668.5090400@jp.fujitsu.com> <4A417176.40008@jp.fujitsu.com>
In-Reply-To: <4A417176.40008@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto wrote:
> Peter, could you put this patch into urgent too? 

Acked-by: Andi Kleen <ak@linux.intel.com> too

(BTW that is needed in interaction with the new timer migration code
that was merged into .31; .30 based kernels don't need it)

-Andi

