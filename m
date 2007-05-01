Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbXEAPHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbXEAPHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 11:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbXEAPHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 11:07:37 -0400
Received: from canuck.infradead.org ([209.217.80.40]:60933 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbXEAPHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 11:07:35 -0400
Subject: Re: condingstyle, was Re: utrace comments
From: David Woodhouse <dwmw2@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Roland McGrath <roland@redhat.com>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <20070501080544.459a6ec9.randy.dunlap@oracle.com>
References: <20061127165138.GA2991@lst.de>
	 <20070430040213.BF9901801A4@magilla.sf.frob.com>
	 <20070430091121.GC31397@infradead.org>
	 <20070430100917.439ebfc8.akpm@linux-foundation.org>
	 <a781481a0704301142sfec317cu8213750c9ab84416@mail.gmail.com>
	 <Pine.LNX.4.64.0705011058330.27246@anakin>
	 <1178028973.2875.78.camel@pmac.infradead.org>
	 <20070501080544.459a6ec9.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Tue, 01 May 2007 16:06:54 +0100
Message-Id: <1178032014.2875.80.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-01 at 08:05 -0700, Randy Dunlap wrote:
> I prefer this format also, but I'm not sure that we can get it
> into CodingStyle.  CodingStyle is about (either) concensus or
> dictum, but I don't see us close to concensus... 

CodingStyle is mostly about consensus. We don't have a consensus, which
is why this particular stuff isn't specified in CodingStyle. :)

-- 
dwmw2

