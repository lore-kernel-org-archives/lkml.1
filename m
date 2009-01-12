Return-Path: <linux-kernel-owner+w=401wt.eu-S1754357AbZALPSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbZALPSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 10:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbZALPSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 10:18:07 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:52129 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbZALPSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 10:18:06 -0500
Subject: Re: Btrfs for mainline
From: Chris Mason <chris.mason@oracle.com>
To: Miguel Figueiredo Mascarenhas Sousa Filipe 
	<miguel.filipe@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>
In-Reply-To: <f058a9c30901120714n55b60bb9h3372983f54d41b6d@mail.gmail.com>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	 <20090111153437.b069d38d.akpm@linux-foundation.org>
	 <1231768730.17356.0.camel@think.oraclecorp.com>
	 <f058a9c30901120714n55b60bb9h3372983f54d41b6d@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 10:17:17 -0500
Message-Id: <1231773437.22806.0.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.496B5F01.0188:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-12 at 15:14 +0000, Miguel Figueiredo Mascarenhas Sousa
Filipe wrote:
> Hi,
> 
> On Mon, Jan 12, 2009 at 1:58 PM, Chris Mason <chris.mason@oracle.com> wrote:
> > On Sun, 2009-01-11 at 15:34 -0800, Andrew Morton wrote:
> >> http://bugzilla.kernel.org/show_bug.cgi?id=12435
> >>
> 
> This is by far the biggest issue btrfs has for simple/domestic users.
> Its probably the most tested miss-feature of btrfs, something almost
> all new testers encounter & report.
> 
> Is fixing this having maximum priority?
> The sooner this is fixed, less energy is spend by everyone
> (entusiasts, testers, bug reporters, bug triagers, mailing list
> campers..etc) and we might save some whales, dolphins and pinguins by
> reducing our carbon footprint. :)
> 

Yes, this definitely at the top of my list.  Along with better
documentation of the project as a whole.

-chris


