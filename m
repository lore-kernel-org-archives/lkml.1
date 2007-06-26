Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbXFZKIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbXFZKIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 06:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbXFZKIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 06:08:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58098 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbXFZKIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 06:08:05 -0400
Message-ID: <4680E57C.9020303@garzik.org>
Date: Tue, 26 Jun 2007 06:07:56 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Sivakumar Subramani <Sivakumar.Subramani@neterion.com>,
       Olaf Hering <olaf@aepfle.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Leonid Grossman <Leonid.Grossman@neterion.com>,
       Rastapur Santosh <santosh.rastapur@neterion.com>,
       Ramkrishna Vepa <ram.vepa@neterion.com>,
       Sriram Rapuru <Sriram.Rapuru@neterion.com>,
       Sreenivasa Honnur <Sreenivasa.Honnur@neterion.com>
Subject: Re: 2.6.22: ERROR: "__ucmpdi2" [drivers/net/s2io.ko] undefined!
References: <20070619204110.GA21384@aepfle.de>	<78C9135A3D2ECE4B8162EBDCE82CAD7701C190FF@nekter> <20070626000132.53330065.akpm@linux-foundation.org>
In-Reply-To: <20070626000132.53330065.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> This fix is still not present in anyone's tree and is required for
> 2.6.22.  Where are we up to with it?


It's in my mbox queue for 2.6.22 (hopefully today).

	Jeff


