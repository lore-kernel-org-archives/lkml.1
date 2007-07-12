Return-Path: <linux-kernel-owner+w=401wt.eu-S935824AbXGLDNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935824AbXGLDNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 23:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765304AbXGLDNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 23:13:31 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:50883 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765267AbXGLDNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 23:13:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=HXK8+JGALWvkyTfzGVtiCx3iStKIELKsq3/i+vDZ7aCckbV8GQpWHiBp5CzhL92P0GC6hOLy12naDQmP1Wnb6vmnx2NsHkAbELVdWpkVd/fTx4Zego4+TL/PeWecbZcfv4QfE6ndCTxxs7vIzMyHsqyn3/hv34gzfRMJAGa2P7o=
Message-ID: <46959C54.6030905@gmail.com>
Date: Thu, 12 Jul 2007 12:13:24 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: caglar@pardus.org.tr, Robert Hancock <hancockr@shaw.ca>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: SATA exceptions
References: <fa.hBFih6KVHDFsBf6Qfg6XispiIuY@ifi.uio.no> <fa.NhBdOmH9+RkW+QO72+TjPRwEKj0@ifi.uio.no> <468FD5ED.5060401@shaw.ca> <200707080035.05718.caglar@pardus.org.tr> <46953E1B.1090306@rtr.ca>
In-Reply-To: <46953E1B.1090306@rtr.ca>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> I'm not even sure how to interpret those numbers.
> It seems rather odd that nearly all fields are either "100" or "253",
> so those are probably pre-programmed numbers rather than actual counts.
> The raw value at the end of the line (for the various "Reallocated*"
> fields)
> is probably the real value here.

I dunno exactly either.  Different vendors seem to use different metrics
anyway but increasing raw number on reallocate counter is pretty easy to
interpret.

-- 
tejun
