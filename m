Return-Path: <linux-kernel-owner+w=401wt.eu-S1753727AbZDGOHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbZDGOHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 10:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbZDGOHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 10:07:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:15020 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbZDGOHU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 10:07:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=e2irSzmjJNweYC2rqzxqAV9uOPqCwfLPtOAPsafbQEs4CHnFvAYWF9CcSTutzoP0WR
         59uhvoH0s6GxiD/h4mJ8aSiOzwdpcJYduQLYo3Av8Le1f18f9neB5+bfBTldEp+j9Epj
         +srscOXxTBuMLbvZIT2fwZDyqX4L3aAsANr2I=
From: Diego Calleja <diegocg@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
Date: Tue, 7 Apr 2009 16:10:47 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-07759-g18b34b9; KDE/4.2.2; x86_64; ; )
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ray Lee <ray-lk@madrabbit.org>, Hua Zhong <hzhong@gmail.com>,
       Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain> <10f740e80904070051u4ec81842u931a405ab5bde985@mail.gmail.com> <20090407103611.GA5910@elte.hu>
In-Reply-To: <20090407103611.GA5910@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904071610.47462.diegocg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Martes 07 Abril 2009 12:36:11 Ingo Molnar escribió:
> Since besides myself i'm not aware of any other person on this 
> planet actually _booting_ allyes/allmod Linux kernels, i guess this 
> is not a big issue anyway :-)

IIRC once I tried to boot an allyes kernel and it oopsed, because (i think)
the probing routines of some drivers have never been tested in machines
that do not have the corresponding hardware. So I doubt someoneone is
using it ;) 
