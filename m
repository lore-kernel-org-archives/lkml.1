Return-Path: <linux-kernel-owner+w=401wt.eu-S1753950AbXFUIBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbXFUIBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 04:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbXFUIBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 04:01:38 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:54815 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbXFUIBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 04:01:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=EFyghLe752jw0SPmAUklTSfcsFT1/pIaCSybN9mguvA0EffHEd4ol1F5nMWFTCV3+FPT7IWkNCkLNWV21sFaUrE05KhD2V4A6pnvj66DbA5koOL68bpT6iR9Sam1f+V0RFI2VFZtTiNXCA0J3X86x+865dFr7xn4iKOpzth46kM=
Message-ID: <467A3055.4070403@gmail.com>
Date: Thu, 21 Jun 2007 12:01:25 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: david@lang.hm
CC: Alexandre Oliva <aoliva@redhat.com>, Andrew McKay <amckay@iders.ca>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Ingo Molnar <mingo@elte.hu>, Daniel Hazelton <dhazelton@enter.net>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br> <20070616181902.GB21478@ftp.linux.org.uk> <or1wgbras9.fsf@oliva.athome.lsd.ic.unicamp.br> <alpine.LFD.0.98.0706161952280.14121@woody.linux-foundation.org> <orabuzkw0i.fsf@oliva.athome.lsd.ic.unicamp.br> <alpine.LFD.0.98.0706171157400.14121@woody.linux-foundation.org> <or3b0qgy8r.fsf@oliva.athome.lsd.ic.unicamp.br> <alpine.LFD.0.98.0706171630150.14121@woody.linux-foundation.org> <orlkeidryp.fsf@oliva.athome.lsd.ic.unicamp.br> <4679557C.5080907@iders.ca> <20070620175627.319a6c55@the-village.bc.nu> <46797C52.4020907@iders.ca> <orodjatk8x.fsf@oliva.athome.lsd.ic.unicamp.br> <Pine.LNX.4.64.0706201412340.30395@asgard.lang.hm> <ord4zqrl0l.fsf@oliva.athome.lsd.ic.unicamp.br> <Pine.LNX.4.64.0706202227160.31603@asgard.lang.hm> <orejk5rg76.fsf@oliva.athome.lsd.ic.unicamp.br> <Pine.LNX.4.64.0706202334420.31603@asgard.lang.hm> <ory7idpykk.fsf@oliva.athome.lsd.ic.unicamp.br> <Pine.LNX.4.64.0706210031280.31603@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0706210031280.31603@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:

> what sort of signal can the network controller send that couldn't be
> forged by the OS?
> 
> how would you do this where the device is a receiver on the netwoek
> (such as a satellite receiver)

just for the question on the HOWTO (not on anything else)

You can easily have scrambled streams with regards to DVB, eg: using
EN50221. Some (like NDS for example in _some_ instances) use proprietary
schemes, but there are standards based methods also. eg: Common
Scrambling Algorithm (CSA)

But in any case, this can be broken down too .. :-)
