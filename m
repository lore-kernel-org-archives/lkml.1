Return-Path: <linux-kernel-owner+w=401wt.eu-S1757484AbYGJOct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484AbYGJOct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 10:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754770AbYGJOcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 10:32:32 -0400
Received: from smtp.nokia.com ([192.100.122.233]:17600 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659AbYGJOcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 10:32:31 -0400
To: "Tomas Winkler" <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Linux Wireless Mini-Summit -- Ottawa -- July 22, 2008
References: <20080709190915.GA8238@tuxdriver.com>
	<1ba2fa240807091713t1158c1ddp81c92ae26a002e46@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Thu, 10 Jul 2008 17:30:47 +0300
In-Reply-To: <1ba2fa240807091713t1158c1ddp81c92ae26a002e46@mail.gmail.com> (ext Tomas Winkler's message of "Thu\, 10 Jul 2008 03\:13\:49 +0300")
Message-ID: <87iqvd3j6w.fsf@nokia.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Jul 2008 14:30:49.0358 (UTC) FILETIME=[8C6852E0:01C8E299]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomas Winkler <tomasw@gmail.com> writes:

>> Although it is already a bit late, I would like to re-open discussions
>> on our agenda for the meeting.  Based on current upstream topics and
>> those persons whom I expect to be attending, I have cobbled together
>> an agenda proposal below.  Please review it and feel free to suggest
>> amendments or alterations, or to elaborate or ask questions about my
>> proposed schedule of topics.
>>
>> I look forward to seeing many of you in Ottawa!
>
> One more topic would be probably
>  power management/power save - connection to system power/power supply
> (Battery/AC)

I'm also very interested about this. mac80211 is lacking any support
for Power Save Mode and I think we should fix that. At least having an
interface to enable and disable PSM would be a start, but we could go
even further than that.

I'm just worried if one day is enough for us. The agenda is getting
quite long already.

-- 
Kalle Valo
