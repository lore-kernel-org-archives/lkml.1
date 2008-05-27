Return-Path: <linux-kernel-owner+w=401wt.eu-S1756677AbYE0GTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbYE0GTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 02:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbYE0GTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 02:19:46 -0400
Received: from smtp.nokia.com ([192.100.122.230]:25240 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbYE0GTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 02:19:46 -0400
Message-ID: <483BA79F.9030100@nokia.com>
Date: Tue, 27 May 2008 09:18:07 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: can UBIFS be taken to linux-next?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 May 2008 06:19:19.0379 (UTC) FILETIME=[98D5A230:01C8BFC1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

we would like to ask for UBIFS mainline inclusion the next merge window.
Of course we cannot say for sure whether Linus will merge it or not,
but it would be helpful to have it in your tree for some time anyway.
UBIFS is already in -mm tree so I assume it should not have too many
build issues.

In case you do agree, here is the URL (for_andrew branch): 

git://git.infradead.org/~dedekind/ubifs-2.6.git for_andrew

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
