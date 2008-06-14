Return-Path: <linux-kernel-owner+w=401wt.eu-S1756070AbYFNW3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbYFNW3T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 18:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755018AbYFNW3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 18:29:08 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:65306 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914AbYFNW3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 18:29:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mTBJMuPhTBDXF++xDP24FU6dkLpPugNsI+M+NJ9hce5aSK1ddy1tyqKSHttsoEX9E/
         9BybLzS6krS3OEP4VHIbzGsSBvMArYfY19sf537KsfxCVJFGut3qjdl+jafZgI+tnupQ
         nsihN93ukrBfu2nsOkAr5TGs3bHj+wVzJh9Qo=
Message-ID: <dd18b0c30806141529xe0a4078m78f52d206c7ae40d@mail.gmail.com>
Date: Sat, 14 Jun 2008 22:29:04 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug 10724] ACPI: EC: GPE storm detected, disabling EC GPE
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>
In-Reply-To: <Jn7irxIunJK.A.XcF.vKDVIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
	 <Jn7irxIunJK.A.XcF.vKDVIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 8:12 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10724
> Subject         : ACPI: EC: GPE storm detected, disabling EC GPE
> Submitter       : Justin Mattock <justinmattock@gmail.com>
> Date            : 2008-05-16 6:17 (30 days old)
> References      : http://marc.info/?l=linux-kernel&m=121091875711824&w=4
>                  http://lkml.org/lkml/2008/5/18/168
>                  http://lkml.org/lkml/2008/5/25/195
>                  http://lkml.org/lkml/2008/5/25/195
> Patch           :  debug EC GPE
>                   debug EC GPE
>                   debug EC GPE
>                   debug EC GPE
>                  http://bugzilla.kernel.org/attachment.cgi?id=16364&action=view
>                  http://bugzilla.kernel.org/attachment.cgi?id=16365&action=view
>                  http://bugzilla.kernel.org/attachment.cgi?id=16364&action=view
>                  http://bugzilla.kernel.org/attachment.cgi?id=16365&action=view
>                   debug EC GPE</a>
>
>
>

I've just pulled the latest git, and applied the latest patch that was
sent to me, I'm not seeing this message at the moment.
I am unsure if the problem is fixed or not.


-- 
Justin P. Mattock
