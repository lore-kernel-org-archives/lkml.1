Return-Path: <linux-kernel-owner+w=401wt.eu-S1753589AbXCZKH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbXCZKH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 06:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbXCZKH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 06:07:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52108 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbXCZKHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 06:07:55 -0400
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
From: David Woodhouse <dwmw2@infradead.org>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: David Lang <david.lang@digitalinsight.com>,
       Thomas Gleixner <tglx@linutronix.de>, Matt Mackall <mpm@selenic.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20070326095113.GA22118@lazybastard.org>
References: <20070321110528.GC3785@lazybastard.org>
	 <1174476334.10840.49.camel@localhost.localdomain>
	 <20070325200826.GA19691@lazybastard.org>
	 <Pine.LNX.4.63.0703251338580.13765@qynat.qvtvafvgr.pbz>
	 <20070325225528.GD19691@lazybastard.org>
	 <1174866394.2866.2.camel@shinybook.infradead.org>
	 <20070326000149.GE19691@lazybastard.org>
	 <1174868485.20505.284.camel@pmac.infradead.org>
	 <20070326010443.GF19691@lazybastard.org>
	 <1174902357.20505.292.camel@pmac.infradead.org>
	 <20070326095113.GA22118@lazybastard.org>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 26 Mar 2007 11:07:46 +0100
Message-Id: <1174903666.20505.305.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6.dwmw2.1) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-26 at 11:51 +0200, Jörn Engel wrote:
> Are you sure?  Do you have any specs or similar that state this?
> 
> So far I have only encountered this limitation by word of mouth.  And
> such a myth coming from ECC effects is nothing that would surprise
> me. 

See pp 6 and 31 of http://david.woodhou.se/TC58DVAM72AF1FT_030124.pdf
for example.

-- 
dwmw2

