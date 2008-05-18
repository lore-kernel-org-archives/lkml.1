Return-Path: <linux-kernel-owner+w=401wt.eu-S1763659AbYERMaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763659AbYERMaQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 08:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761735AbYERMSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 08:18:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:54732 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760670AbYERMSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 08:18:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sTxXmhYqlQ7HHywY7ALnwdM7WG4sQOa0rjTKpZQE6mTN6XkpZZ3n4WawLiT9M90fBMBJndStbKct6rUIamOcj/A9J+oihIWYZo1cf1qEDSLN4iL4cnWkO/vW2FP3Kh9ZdIU3ZYUDD3NUyuGaWdZpcmM0/g2U/oKCLrEGWeT6D3s=
Message-ID: <19f34abd0805180518m54dc2799h581ceb864845b1ea@mail.gmail.com>
Date: Sun, 18 May 2008 14:18:49 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10669] ACPI: kmemcheck: Caught 16-bit read from freed memory (f7c12ec6)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Lin Ming" <ming.m.lin@intel.com>
In-Reply-To: <7wuznNhcUqC.A.GY.vsBMIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>
	 <7wuznNhcUqC.A.GY.vsBMIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, May 18, 2008 at 1:13 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10669
> Subject         : ACPI: kmemcheck: Caught 16-bit read from freed memory (f7c12ec6)
> Submitter       : Vegard Nossum <vegard.nossum@gmail.com>
> Date            : 2008-05-06 16:09 (13 days old)
> References      : http://marc.info/?l=linux-acpi&amp;m=121009034825514&amp;w=4
> Handled-By      : Lin Ming <ming.m.lin@intel.com>
>

I got this from Andrew a couple of days ago:

----
The patch titled
    revert "ACPICA: Fixes for Unload and DDBHandles"
has been removed from the -mm tree.  Its filename was
    revert-acpica-fixes-for-unload-and-ddbhandles.patch

This patch was dropped because it was merged into mainline or a subsystem tree
----

But I don't know which tree it was merged into. It doesn't seem to be
in ACPI tree anyway.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
