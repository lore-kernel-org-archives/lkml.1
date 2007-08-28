Return-Path: <linux-kernel-owner+w=401wt.eu-S1755096AbXH1GoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbXH1GoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 02:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbXH1GoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 02:44:08 -0400
Received: from mx1.rz.ruhr-uni-bochum.de ([134.147.32.86]:53671 "HELO
	mx1.rz.ruhr-uni-bochum.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751392AbXH1GoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 02:44:06 -0400
Subject: Re: Problems with disc-performance and libata
From: Oliver Janscheidt <oliver.janscheidt@rub.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <1188197040.6622.21.camel@WG4>
References: <1188158937.6896.4.camel@WG4>
	 <6bffcb0e0708261659y15b344b7h783a1f5ea43a3899@mail.gmail.com>
	 <1188197040.6622.21.camel@WG4>
Content-Type: text/plain
Date: Tue, 28 Aug 2007 08:44:00 +0200
Message-Id: <1188283440.6606.14.camel@WG4>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

yesterday I compiled a new kernel (2.6.23-rc3-git10) from Vanilla
sources and it works!

sudo hdparm -t /dev/scd0 now gives:
Timing buffered disk reads:   14 MB in  3.22 seconds =   4.34 MB/sec

So, after crawling the web for more than three weeks, this is the
solution. :) Therefore other things stop working, but these are another
road works. 

Thanks,

Oli

