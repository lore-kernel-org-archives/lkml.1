Return-Path: <linux-kernel-owner+w=401wt.eu-S1761572AbXE1JMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761572AbXE1JMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 05:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191AbXE1JMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 05:12:38 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:34439 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095AbXE1JMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 05:12:38 -0400
Date: Mon, 28 May 2007 11:13:36 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add a trivial patch style checker
Message-ID: <20070528091336.GA27248@uranus.ravnborg.org>
References: <9a1288909c10f2935af82ec5cea0c46b@pinky>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a1288909c10f2935af82ec5cea0c46b@pinky>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/scripts/patch-trivia-detector.pl b/scripts/patch-trivia-detector.pl
> new file mode 100755
> index 0000000..e71c4ef
> --- /dev/null
> +++ b/scripts/patch-trivia-detector.pl

Could we please name this checkpatch.pl to follow naming style in scripts/
The namespace check* and clean* and mk* is well established so it is preferred
that we stick to it.

The patch-trivia-detector was a nice working name but as it enters the kernel
it is better that it follows the surroundings.

	Sam
