Return-Path: <linux-kernel-owner+w=401wt.eu-S1758635AbYHJA1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635AbYHJA1m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 20:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757654AbYHJAZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 20:25:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:42479 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757720AbYHJAZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 20:25:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sg354K42JIt+NnLGsh2dhF57yOgcGDuLC+y8B3i7AhKYKM2/jIsEV6wXzmp42/ebhG
         4GuQs61vy+AAZy8wlDpCCBT9ItVEr38ccpqfist0O3QNRrTLOqZj2CCpMcykyrznwkls
         Wt5CadjP5d0MDWDh8Loolx/Wgm0vHMy1hg8Rg=
Message-ID: <dd18b0c30808091725s5974befdp4b57fe54d3d6e255@mail.gmail.com>
Date: Sat, 9 Aug 2008 17:25:44 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11277] BUG kmalloc-64: Object already free
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Parag Warudkar" <parag.warudkar@gmail.com>
In-Reply-To: <cX_-nNkxKaF.A.TX.0CjnIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik>
	 <cX_-nNkxKaF.A.TX.0CjnIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 9, 2008 at 3:43 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=11277
> Subject         : BUG kmalloc-64: Object already free
> Submitter       : Justin Mattock <justinmattock@gmail.com>
> Date            : 2008-08-06 21:21 (4 days old)
> References      : http://marc.info/?l=linux-kernel&m=121805862910241&w=4
> Handled-By      : Parag Warudkar <parag.warudkar@gmail.com>
> Patch           : http://marc.info/?l=linux-kernel&m=121814402609514&w=4
>
>
>

I think this bug report can be closed.


-- 
Justin P. Mattock
