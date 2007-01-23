Return-Path: <linux-kernel-owner+w=401wt.eu-S932855AbXAWLKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855AbXAWLKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 06:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932968AbXAWLKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 06:10:42 -0500
Received: from relay.gothnet.se ([82.193.160.251]:7900 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932855AbXAWLKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 06:10:42 -0500
Message-ID: <45B5C2FD.6090100@tungstengraphics.com>
Date: Tue, 23 Jan 2007 09:10:37 +0100
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20060921)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Tilman Schmidt <tilman@imap.cc>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       Dave Airlie <airlied@linux.ie>
Subject: Re: i810fb fails to load
References: <20070111222627.66bb75ab.akpm@osdl.org> <45AAC244.8060607@imap.cc>	 <20070114162235.4c8d241f.akpm@osdl.org>	 <45B4BF50.9010105@tungstengraphics.com> <21d7e9970701221350h3a8959faqcd099bf4e0a761fa@mail.gmail.com>
In-Reply-To: <21d7e9970701221350h3a8959faqcd099bf4e0a761fa@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:
>> >>
>> >>
>> >
>> > Don't know.  But I bet someone on the Cc does...
>> >
>> Tilman,
>> Thanks for reporting.
>> Can you try the attached patch to see if that fixes the problem.
>>
>
> Hi Thomas,
>
> This also fixes X starting on old i810/5 hardware, I had noticed it
> broken but hadn't had time to investigate it, this patch fixes it...
>
> Dave.
Great.
The oldest hardware I have is an i915 which hampers me a bit.

/Thomas



