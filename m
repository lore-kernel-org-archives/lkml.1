Return-Path: <linux-kernel-owner+w=401wt.eu-S1753539Ab0ALIKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab0ALIKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 03:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949Ab0ALIK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 03:10:29 -0500
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.104]:33094
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752154Ab0ALIK3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 03:10:29 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqMBAJ69S0t8qNcX/2dsb2JhbAAI1giEMAQ
X-IronPort-AV: E=Sophos;i="4.49,261,1262534400"; 
   d="scan'208";a="497149411"
Subject: Re: [staging/hv] why it not follow kernel codingstyle?
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Ben Nizette <bn@niasdigital.com>
In-Reply-To: <4B4C1FED.7010603@126.com>
Date: Tue, 12 Jan 2010 19:10:24 +1100
Cc: gregkh@suse.de, hjanssen@microsoft.com, haiyangz@microsoft.com,
       torvalds@linux-foundation.org, akpm@osdl.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <C8E484CB-24FD-4610-896F-693A64B798AC@niasdigital.com>
References: <4B4C16CA.4010401@126.com> <4B4C1FED.7010603@126.com>
To: "Figo.zhang" <figo1802@126.com>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/01/2010, at 6:08 PM, Figo.zhang wrote:

> hi all,
> 
> i read the driver/staging/hv code, why it will apply into kernel tree that it not follow the kernel codingstyle?

Drivers in the staging/ tree are there because they aren't clean and neat enough for the rest of the kernel tree.  By the time it gets promoted to /virt (or where ever) it will have been fixed.

If the state of hv worries you, send patches!

	--Ben.