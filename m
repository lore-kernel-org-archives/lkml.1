Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbZFEJCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbZFEJCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 05:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbZFEJCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 05:02:13 -0400
Received: from smtp.nokia.com ([192.100.122.233]:25870 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbZFEJCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 05:02:12 -0400
Message-ID: <4A28DEEE.7020105@nokia.com>
Date: Fri, 05 Jun 2009 12:01:34 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Felix Blyakher <felixb@sgi.com>
CC: Artem Bityutskiy <dedekind@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 01/17] VFS: introduce helpers for manipulation s_dirty
 flag
References: <1244112114-23144-1-git-send-email-dedekind@infradead.org> <1244112114-23144-2-git-send-email-dedekind@infradead.org> <5DFB5844-7C2C-4987-BC20-6CC81E0BF1BD@sgi.com>
In-Reply-To: <5DFB5844-7C2C-4987-BC20-6CC81E0BF1BD@sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 Jun 2009 09:01:39.0339 (UTC) FILETIME=[3CCC15B0:01C9E5BC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Felix Blyakher wrote:
> On Jun 4, 2009, at 5:41 AM, Artem Bityutskiy wrote:
> 
>> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
>>
>> This patch introduces 3 new VFS helpers: 'mark_sb_dirty()',
>> 'mark_sb_clean()', and 'sb_is_dirty()'.
> 
> Should the name be is_sb_dirty() for consistency?

OK, will re-name and re-send, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
