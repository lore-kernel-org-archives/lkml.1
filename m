Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbYLDOVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbYLDOVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 09:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbYLDOVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 09:21:12 -0500
Received: from smtp.nokia.com ([192.100.122.230]:37457 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbYLDOVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 09:21:10 -0500
Message-ID: <4937E6AE.9040302@nokia.com>
Date: Thu, 04 Dec 2008 16:18:22 +0200
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: next-2008-12-04: ubifs section fixlet
References: <20081204200745.eff0ac87.sfr@canb.auug.org.au> <20081204140418.GB13953@x200.localdomain>
In-Reply-To: <20081204140418.GB13953@x200.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 04 Dec 2008 14:20:25.0125 (UTC) FILETIME=[730F2D50:01C9561B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> Please, fold into 552ff3179d1e93a3e982357544c059f3e9a5516e
> aka "UBIFS: add debugfs support":
> 
> WARNING: fs/ubifs/ubifs.o(.init.text+0xec): Section mismatch in reference from the function init_module() to the function .exit.text:ubifs_compressors_exit()

Pushed to ubifs-2.6.git, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

