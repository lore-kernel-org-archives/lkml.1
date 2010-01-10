Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570Ab0AJWtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab0AJWtW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 17:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229Ab0AJWtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 17:49:20 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:20897 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab0AJWtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 17:49:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fUVwgbGx/NaXpA9N7fFKtWTArLSVzZ20rKz/EbIXpcyu0mDjTu/JBkThbb5viRSKpB
         LbPh0f8uM9Yd7NMatInp1AOexXx8XpGy9l33dRzx3T3/fHpynaeN5CvpQkIwmw54nWNZ
         DGXNGzpMPVV2igZ+EVk6+MLo3+Xgkke9nlD6c=
Date: Sun, 10 Jan 2010 23:49:15 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: [Bug #14899] reiserfs: inconsistent lock state
Message-ID: <20100110224914.GB5039@nowhere>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera> <omZ8aBZReyD.A.vd.qNlSLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <omZ8aBZReyD.A.vd.qNlSLB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 10, 2010 at 11:32:53PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14899
> Subject		: reiserfs: inconsistent lock state
> Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
> Date		: 2009-12-11 22:06 (31 days old)
> References	: http://marc.info/?l=linux-kernel&m=126056920702515&w=4
> Handled-By	: Frederic Weisbecker <fweisbec@gmail.com>
> Patch		: http://patchwork.kernel.org/patch/67256/
> 		  http://patchwork.kernel.org/patch/67257/



The fix have been pulled upstream. Would be nice to have Alexander
confirmation that it's really fixed though.

