Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbZBJHs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbZBJHs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 02:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbZBJHss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 02:48:48 -0500
Received: from smtp.nokia.com ([192.100.122.233]:49176 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbZBJHss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 02:48:48 -0500
Message-ID: <49913126.7030906@nokia.com>
Date: Tue, 10 Feb 2009 09:47:50 +0200
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Damien Wyart <damien.wyart@free.fr>
CC: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Federico Cuello <fedux@lugmen.org.ar>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] write-back: fix break condition
References: <1233977610-8919-1-git-send-email-fedux@lugmen.org.ar> <20090209152140.aa3f50aa.akpm@linux-foundation.org> <20090210003452.GA26143@wotan.suse.de> <20090210062249.GA5224@localhost.localdomain>
In-Reply-To: <20090210062249.GA5224@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 10 Feb 2009 07:47:49.0354 (UTC) FILETIME=[DED0C4A0:01C98B53]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Damien Wyart wrote:
>>> Artem, Nick, please check?
> 
>> Yes, this looks OK by me.
> 
>> Acked-by: Nick Piggin <npiggin@suse.de>
> 
> Shouldn't this go to stable 2.6.28, too ? They have not been in Cc for
> now. I think the problem was at first detected in 2.6.28.X, but it is
> not yet sure if it is solved or if this interacts with some ext4
> problems.

It seems like this and my previous patch should go together to 2.6.28.X.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
