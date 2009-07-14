Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbZGNKcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbZGNKcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 06:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562AbZGNKcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 06:32:51 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:62864 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754318AbZGNKcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 06:32:50 -0400
Subject: Re: [PATCH] x86: _edata should include all .data.* sections on
	X86_64
From: Catalin Marinas <catalin.marinas@arm.com>
To: Alexey Fisher <bug-track@fisher-privat.net>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       x86@kernel.org
In-Reply-To: <4A5C5A59.5080304@fisher-privat.net>
References: <4A5C20E5.6010203@fisher-privat.net>
	 <84144f020907140019g511723dctb541f6333d1a082b@mail.gmail.com>
	 <4A5C41C8.7040904@fisher-privat.net>
	 <1247564356.28240.30.camel@pc1117.cambridge.arm.com>
	 <1247565175.28240.37.camel@pc1117.cambridge.arm.com>
	 <4A5C5A59.5080304@fisher-privat.net>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 14 Jul 2009 11:31:39 +0100
Message-Id: <1247567499.28240.48.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jul 2009 10:31:41.0081 (UTC) FILETIME=[4698C090:01CA046E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-14 at 12:13 +0200, Alexey Fisher wrote:
> With this patch i have only 25 reports....
> but i still have a lot of ext4 and some other reports.

Apart from ext4, what are the other reports?

Thanks.

-- 
Catalin

