Return-Path: <linux-kernel-owner+w=401wt.eu-S1755590AbYH1SQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbYH1SQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYH1SQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:16:13 -0400
Received: from relay1.sgi.com ([192.48.171.29]:56824 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751947AbYH1SQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:16:12 -0400
Date: Thu, 28 Aug 2008 13:16:08 -0500
From: Paul Jackson <pj@sgi.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: akpm@linux-foundation.org, elendil@planet.nl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: [regression?] [resend] Memory zone info seems incomplete in
 boottime dmesg output
Message-Id: <20080828131608.4253aa99.pj@sgi.com>
In-Reply-To: <20080815100552.GA27547@csn.ul.ie>
References: <200808142042.24606.elendil@planet.nl>
	<20080814121349.b77e0116.akpm@linux-foundation.org>
	<20080815100552.GA27547@csn.ul.ie>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans, quoted by Mel (two weeks ago ;):
> > P.S. As a user I really don't find the hex values easier to read/use than 
> > the decimal values. Except maybe for the "Zone PFN ranges" where things 
> > seem to be nicely aligned.

I suppose that for smaller systems, such as what would be a normal
size 32 bit system these days, it's a bit of preference, but for
larger systems, such as 64 bit systems or future "normal" systems,
it weighs more heavily toward the hex format.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
