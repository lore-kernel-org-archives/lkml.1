Return-Path: <linux-kernel-owner+w=401wt.eu-S1759812AbZDCGx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759812AbZDCGx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 02:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889AbZDCGxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 02:53:51 -0400
Received: from smtp.nokia.com ([192.100.105.134]:52158 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbZDCGxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 02:53:50 -0400
Message-ID: <49D5B26A.3040703@nokia.com>
Date: Fri, 03 Apr 2009 09:53:30 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: ext Christian Kujau <lists@nerdbynature.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: EXT4-ish "fixes" in UBIFS
References: <49CCCB0A.6070701@nokia.com> <alpine.DEB.2.01.0904021706330.6162@bogon.housecafe.de>
In-Reply-To: <alpine.DEB.2.01.0904021706330.6162@bogon.housecafe.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Apr 2009 06:53:32.0495 (UTC) FILETIME=[E70E85F0:01C9B428]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Christian Kujau wrote:
> On Fri, 27 Mar 2009, Artem Bityutskiy wrote:
>> They just say - this is file-system bug, it is fixed in
>> ext4 now, just fix the bug in UBIFS.
> 
> Would *mounting* the filesystem with "-o sync" help? This way no 
> filesystem "fixes" are needed and userland would not have to be rewritten.

It would, but the overall FS performance would suffer a lot too.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
