Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbXFDKmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbXFDKmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 06:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbXFDKmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 06:42:16 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:58545 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbXFDKmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 06:42:16 -0400
Date: Mon, 4 Jun 2007 12:43:17 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: alpha modpost warnings
Message-ID: <20070604104317.GA14589@uranus.ravnborg.org>
References: <Pine.SOC.4.64.0706041308560.7370@math>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.SOC.4.64.0706041308560.7370@math>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Something for COMMON symbols was fixed for powerpc recently, the warning 
> is gone there.

For PowerPC the symbol was declared .common in the .S file.

	Sam
