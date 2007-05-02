Return-Path: <linux-kernel-owner+w=401wt.eu-S1030894AbXEBGeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030894AbXEBGeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 02:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030918AbXEBGeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 02:34:31 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:10766 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030894AbXEBGea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 02:34:30 -0400
Message-ID: <463830E1.8080107@interia.pl>
Date: Wed, 02 May 2007 08:34:09 +0200
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 1.5.0.10 (X11/20070321)
MIME-Version: 1.0
To: Tim Hockin <thockin@hockin.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Natsemi DP83815 driver spaming
References: <46365887.3010705@interia.pl>	 <20070430205522.abad2481.akpm@linux-foundation.org>	 <20070501084639.GA528@sirena.org.uk> <46371590.4090004@interia.pl>	 <20070501180830.GA31630@sirena.org.uk> <46379A7E.3000109@interia.pl>	 <20070501212750.GC31630@sirena.org.uk>	 <b3ece790705011543gdca3a9ei905d3499b6c18dc8@mail.gmail.com>	 <46382798.2090709@interia.pl> <b3ece790705012303x1e5a2d03xddf6c14aec5a99d8@mail.gmail.com>
In-Reply-To: <b3ece790705012303x1e5a2d03xddf6c14aec5a99d8@mail.gmail.com>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
X-EMID: 2209aacc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
> 
>> With code commented out I have 1 error / 30000 transmitted packets from
>> DP83815C. I have 1 error / 100000 transmitted packets to DP83815C. Maybe
>> it works at all because I have short cable, only 10m long.
>> I don't remember any errors with plain 2.6.21.1.
Sorry. I mean transmition errors, but of course log was full of "wakeup" 
messages. 
> Well, I certainly haven't changed anything in there.  If the behavior
> has changed in recent kernels, check the rest of the diffs.
> 
> Tim

2.6.21.1 is first kernel which I'm using at this device. Earlier it was 
WindowsCE terminal. It is hardware fault. Commenting out the code is my 
way to avoid "wakeup" messages in log, but I don't want to change anything 
in vanilla kernel. I'm lucky that NIC is working at all.

Thank You
Rafa³



----------------------------------------------------------------------
NIE KUPUJ!!!
...zanim nie porownasz cen >> http://link.interia.pl/f1a5e



