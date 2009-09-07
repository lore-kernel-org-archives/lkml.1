Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbZIGPZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbZIGPZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 11:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbZIGPZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 11:25:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56564 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414AbZIGPZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 11:25:53 -0400
Date: Mon, 7 Sep 2009 11:25:53 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Felix Blyakher <felixb@sgi.com>,
       Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [Bug #13949] XFS regression
Message-ID: <20090907152553.GA21768@infradead.org>
References: <aIL9jMAYJnG.A.WjH.M3BpKB@chimera> <hKF51Pczj6N.A.bvH.Y3BpKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <hKF51Pczj6N.A.bvH.Y3BpKB@chimera>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 06, 2009 at 08:11:51PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).

While this still isn't fixed it has been tracked down to a regression
in the loop driver.  Care to adjust the subject?

