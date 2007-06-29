Return-Path: <linux-kernel-owner+w=401wt.eu-S1757283AbXF2WKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbXF2WKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 18:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbXF2WKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 18:10:08 -0400
Received: from main.gmane.org ([80.91.229.2]:51349 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755389AbXF2WKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 18:10:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Rene Herman <rene.herman@gmail.com>
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Date: Fri, 29 Jun 2007 22:04:22 +0000 (UTC)
Message-ID: <loom.20070630T000258-512@post.gmane.org>
References: <fa.C+RaPJT9DzfOowG03yiRkB6ItF8@ifi.uio.no> <fa.eZW1VxypFFwQqmC93xQaStxDK0Q@ifi.uio.no> <fa.n+OzEywqHGabZtz5NxmlX4rEY0A@ifi.uio.no> <46845D77.3030908@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 82.73.12.33 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070515 Firefox/2.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock <hancockr <at> shaw.ca> writes:

> In the case of S/PDIF output on ice1724 (and probably other cards), it 
> would be nice if ALSA defaulted to routing default audio to both the 
> S/PDIF and analog ports, as this is what most users would normally 
> expect.. The Windows drivers work like that, but on Linux you have to 
> pick one or the other (at least without a bunch of mucking with the 
> config file).

I believe some cards can't do this in fact which might be argument due to
consistency. Otherwise I don't so much have an opinion on whether or not this
should be default though...

Rene




