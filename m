Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbYCNRVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbYCNRVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 13:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbYCNRVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 13:21:25 -0400
Received: from catapult-mx.catapult.com ([192.94.66.29]:2019 "EHLO
	Catapult-mx.catapult.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbYCNRVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 13:21:24 -0400
Subject: Re: Timer interrupt stops, causes soft lockup
From: "Joel K. Greene" <joel.greene@catapult.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080314093814.3147f250@laptopd505.fenrus.org>
References: <1204653133.718.14.camel@linuxdt036.nc.catapult.com>
	 <47CD634E.2828.00B3.0@novell.com>
	 <1204722318.6578.12.camel@linuxdt036.nc.catapult.com>
	 <47CE45D8.2828.00B3.0@novell.com>
	 <1204728175.6578.23.camel@linuxdt036.nc.catapult.com>
	 <47D3DC53.2828.00B3.0@novell.com>
	 <1205152374.18463.17.camel@linuxdt036.nc.catapult.com>
	 <1205235450.18463.45.camel@linuxdt036.nc.catapult.com>
	 <47D6423D.1E6F.00AA.0@novell.com>
	 <1205255048.18463.60.camel@linuxdt036.nc.catapult.com>
	 <1205260328.18463.67.camel@linuxdt036.nc.catapult.com>
	 <47D68B9D.1E6F.00AA.0@novell.com>
	 <1205265642.18463.82.camel@linuxdt036.nc.catapult.com>
	 <1205322793.20205.9.camel@linuxdt036.nc.catapult.com>
	 <1205326713.20205.27.camel@linuxdt036.nc.catapult.com>
	 <1205332212.20205.33.camel@linuxdt036.nc.catapult.com>
	 <1205510009.29658.83.camel@linuxdt036.nc.catapult.com>
	 <20080314093814.3147f250@laptopd505.fenrus.org>
Content-Type: text/plain
Organization: Catapult Communications Corporation
Date: Fri, 14 Mar 2008 13:21:22 -0400
Message-Id: <1205515282.29658.111.camel@linuxdt036.nc.catapult.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

Thanks for your response. 

Sorry for the long post, I think the issue required a lot of detail. I'm
sure that it was easy to overlook that this is still an issue in a 6
week old kernel:
>  Yesterday I pulled down 2.6.16.60 from kernel.org and built that
> kernel with HZ=1000 and reproduced the problem in about 7 hours.

It looks like from http://www.kernel.org/pub/linux/kernel/v2.6/ that .16
is the longest-running subversion and is still being maintained. Is
there a better list for 2.6.16 issues?

I am testing 2.6.24.3 now. I am not going tickless. I am not using PIT
with any of the kernels I am testing.



Thanks,
Joel.

