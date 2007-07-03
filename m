Return-Path: <linux-kernel-owner+w=401wt.eu-S1759275AbXGCIVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275AbXGCIVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 04:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbXGCIVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 04:21:06 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:60108 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbXGCIVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 04:21:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=fkL4GrsnMHW/jHHoxyOuOcIqzrtabgJZySeCQSsjjr4yaypdxjIX9fQ5Cd7MwAPuRthHuhsph0VBJy6mfgIweFTk7VCpihaqDT+oyYRn2IqSzvxX9lIwnJePI0lA8uyW/idB10o0Soc6FVkCO26GvmlFvhJ93wipmkomHUo1beQ=
Message-ID: <468A06A0.1020802@gmail.com>
Date: Tue, 03 Jul 2007 17:19:44 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: Some NCQ numbers...
References: <468392CE.6010206@msgid.tls.msk.ru>
In-Reply-To: <468392CE.6010206@msgid.tls.msk.ru>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev wrote:
> [Offtopic notice: For the first time I demonstrated some
> speed testing results on linux-ide mailinglist, as a
> demonstration how [NT]CQ can help.  But later, someone
> becomes curious and posted that email to lkml, asking
> for more details.  Since that, I become more curious
> as well, and decided to look at it more closely.
> Here it goes...]
> 
> A test drive is Seagate Barracuda ST3250620AS "desktop" drive,
> 250Gb, cache size is 16Mb, 7200RPM.

And which elevator?

-- 
tejun
