Return-Path: <linux-kernel-owner+w=401wt.eu-S1030383AbXBTU4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030383AbXBTU4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 15:56:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030386AbXBTU4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 15:56:49 -0500
Received: from mail.tmr.com ([64.65.253.246]:48006 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030383AbXBTU4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 15:56:49 -0500
Message-ID: <45DB5D80.3050008@tmr.com>
Date: Tue, 20 Feb 2007 15:43:44 -0500
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Juan Piernas Canovas <piernas@ditec.um.es>
CC: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@lazybastard.org>,
       Sorin Faibish <sfaibish@emc.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
References: <Pine.LNX.4.61.0702142251460.19368@yvahk01.tjqt.qr> <Pine.LNX.4.61.0702151910370.19998@ditec.inf.um.es> <20070215200922.GB24643@lazybastard.org> <Pine.LNX.4.61.0702152353060.19998@ditec.inf.um.es> <20070216091321.GA28092@lazybastard.org> <45D642A4.5010009@tmr.com> <20070217151108.GA301@lazybastard.org> <45D7450F.6090309@tmr.com> <20070217183646.GE301@lazybastard.org> <op.tnwuonh3rwwil4@muki-1mj5c5mxes> <20070218055936.GF301@lazybastard.org> <Pine.LNX.4.61.0702190625270.8828@ditec.inf.um.es>
In-Reply-To: <Pine.LNX.4.61.0702190625270.8828@ditec.inf.um.es>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Juan Piernas Canovas wrote:
>
> The point of all the above is that you must improve the common case, 
> and manage the worst case correctly. 
That statement made it to my quote file. Of course "correctly" hopefully 
means getting to the desired behavior without a performance hit so bad 
it becomes a "jackpot case" and is correct in result but too slow to be 
useful.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

