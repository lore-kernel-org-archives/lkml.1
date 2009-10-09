Return-Path: <linux-kernel-owner+w=401wt.eu-S932503AbZJIETo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503AbZJIETo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 00:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbZJIETo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 00:19:44 -0400
Received: from smtp.nokia.com ([192.100.105.134]:40401 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbZJIETn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 00:19:43 -0400
Message-ID: <4ACEB95C.5080501@nokia.com>
Date: Fri, 09 Oct 2009 07:17:32 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: "ext Narnakaje, Snehaprabha" <nsnehaprabha@ti.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
       "Pedanekar, Hemant" <hemantp@ti.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "dwmw2@infradead.org" <dwmw2@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mtd: nand: davinci: fix to use mask_ale from pdata
References: <1254407106-19390-1-git-send-email-hemantp@ti.com> <87tyy9dih1.fsf@deeprootsystems.com> <7A436F7769CA33409C6B44B358BFFF0C012A6FC76F@dlee02.ent.ti.com>
In-Reply-To: <7A436F7769CA33409C6B44B358BFFF0C012A6FC76F@dlee02.ent.ti.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 09 Oct 2009 04:17:35.0261 (UTC) FILETIME=[6DC8ACD0:01CA4897]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2009 06:37 PM, ext Narnakaje, Snehaprabha wrote:
> Andrew,
>
> Could you please apply this patch to the -mm tree and thus queue it up for 2.6.32-rc series?

FYI, this patch is already in the mtd-2.6.git tree. So you should bug
dwmw2 to push it to rc3

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
