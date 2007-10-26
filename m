Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbXJZTqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbXJZTqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 15:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbXJZTpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 15:45:53 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:55144 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbXJZTpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 15:45:52 -0400
Date: Fri, 26 Oct 2007 21:47:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Check handling of kernel build output directory
Message-ID: <20071026194727.GA23871@uranus.ravnborg.org>
References: <fft89p$rko$1@ger.gmane.org> <20071026190500.GA23480@uranus.ravnborg.org> <ffteuq$n3b$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffteuq$n3b$1@ger.gmane.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I did that clean-up step.

You did it in your output directory I assume.
kbuild complains that the source directory is not clean - which
is what you need to clean up.

	Sam
