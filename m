Return-Path: <linux-kernel-owner+w=401wt.eu-S1756893AbYEGIMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbYEGIMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 04:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbYEGIMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 04:12:07 -0400
Received: from smtp.nokia.com ([192.100.105.134]:28760 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100AbYEGIME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 04:12:04 -0400
Message-ID: <48216440.1020609@nokia.com>
Date: Wed, 07 May 2008 11:11:44 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [PATCH take 2] UBIFS - new flash file system
References: <1210070159-22794-1-git-send-email-Artem.Bityutskiy@nokia.com> <20080507080153.GB23621@infradead.org> <48216353.3020202@nokia.com> <20080507081001.GA14614@infradead.org>
In-Reply-To: <20080507081001.GA14614@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 07 May 2008 08:11:54.0555 (UTC) FILETIME=[02F8B0B0:01C8B01A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Christoph Hellwig wrote:
> On Wed, May 07, 2008 at 11:07:47AM +0300, Artem Bityutskiy wrote:
>> Christoph Hellwig wrote:
>>> Do you have the filesystem as a single tarball or patch?  This cancer
>>> of split-up patches that's spreading quickly all over the linux world
>>> makes sensible reviews quite hard unfortunately.
>> Will git tree work?
>> http://www.linux-mtd.infradead.org/doc/ubifs.html#L_source
> 
> A git tree of just ubifs would be perfect, but the full tree does it
> aswell.  Not really conveniant, but much better than split patches :)

Wait a little, I'll prepare current linux-2.6.git + ubifs tree.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
