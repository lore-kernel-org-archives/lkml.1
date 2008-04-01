Return-Path: <linux-kernel-owner+w=401wt.eu-S1758403AbYDAJuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403AbYDAJuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 05:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756013AbYDAJuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 05:50:39 -0400
Received: from smtp.nokia.com ([192.100.105.134]:23364 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829AbYDAJui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 05:50:38 -0400
Message-ID: <47F20464.4070202@yandex.ru>
Date: Tue, 01 Apr 2008 12:46:12 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
CC: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>, joern@lazybastard.org
Subject: Re: UBIFS vs Logfs (was [RFC PATCH] UBIFS - new flash file system)
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com> <alpine.LNX.1.10.0803311428270.2554@fbirervta.pbzchgretzou.qr> <47F0DD49.7010302@nokia.com> <20080331132047.GA31660@logfs.org> <47F1C78D.2050300@yandex.ru> <20080401091945.GB7465@logfs.org>
In-Reply-To: <20080401091945.GB7465@logfs.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Apr 2008 09:50:03.0073 (UTC) FILETIME=[C1EE3B10:01C893DD]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> Write-back of data: currently not.

Taking into account this, bad block handling and other stuff I kindly ask you
not to do these "tricky" things like comparing amount of code lines.
I believe if you implement all the things, you'll have _way_ more code. I
believe you'll even have to re-design many things because write-back really
affects the design a lot. Let's be fair.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
