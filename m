Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbYC1GvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbYC1GvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 02:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754008AbYC1Guy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 02:50:54 -0400
Received: from smtp.nokia.com ([192.100.105.134]:44349 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987AbYC1Gux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 02:50:53 -0400
Message-ID: <47EC9407.90501@yandex.ru>
Date: Fri, 28 Mar 2008 08:45:27 +0200
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [RFC PATCH] UBIFS - new flash file system
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>
In-Reply-To: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 28 Mar 2008 06:48:17.0732 (UTC) FILETIME=[B4304040:01C8909F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a typo, let me fix it.

Artem Bityutskiy wrote:
> Note, UBIFS works on top of UBI, not on top of bare flash devices.
> It delegates crucial things like garbage-collection and bad
s/garbage-collection/wear-leveling/. Of course GC is done on the FS level :-)

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
