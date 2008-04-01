Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbYDAGET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbYDAGET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 02:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbYDAGEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 02:04:10 -0400
Received: from smtp.nokia.com ([192.100.122.233]:28772 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbYDAGEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 02:04:09 -0400
Message-ID: <47F1CF62.6010808@yandex.ru>
Date: Tue, 01 Apr 2008 09:00:02 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       LKML <linux-kernel@vger.kernel.org>, joern@lazybastard.org
Subject: Re: [RFC PATCH] UBIFS - new flash file system
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com> <alpine.LNX.1.10.0803311428270.2554@fbirervta.pbzchgretzou.qr> <47F0DD49.7010302@nokia.com> <20080331132047.GA31660@logfs.org> <47F0EE63.3060401@nokia.com> <20080331171757.GA2077@logfs.org> <84144f020803311349w7f1b83e8x174ada25ffc85215@mail.gmail.com> <20080331212133.GA2388@logfs.org>
In-Reply-To: <20080331212133.GA2388@logfs.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Apr 2008 06:03:50.0679 (UTC) FILETIME=[28274270:01C893BE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
 > You don't have to wait long.  I was thinking about sending a patch out
> tomorrow.
If you do not mind, could you please tell about all crucial features which
are not implemented (but have to) like bad eraseblock handling when you
send the patch-set?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
