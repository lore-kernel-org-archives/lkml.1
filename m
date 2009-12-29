Return-Path: <linux-kernel-owner+w=401wt.eu-S1752019AbZL2Sfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbZL2Sfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 13:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbZL2Sf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 13:35:29 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:60270 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbZL2Sf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 13:35:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ISsIYixgtzzMu5wMlEsFx0WMhuPxtkPc+HX7NfX6bIrucmOW1KL2KL6TWgjga6GmiE
         kjKMChO/IOj5kDpmwAV944qGsVpemrVjwFxjNDBqGaKH4E2EPtWvb1Z/oUnairamzido
         C6+zmO6Vpq1Es6wx86kGd0k4VSjG2AXIdFFCg=
Date: Tue, 29 Dec 2009 19:35:23 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Bernard Pidoux <bernard.pidoux@upmc.fr>
Subject: Re: [Bug #14905] kernel BUG at kernel/timer.c:951!
Message-ID: <20091229183522.GB3081@del.dom.local>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
 <srmJ8vMxKPH.A.2YB.JwhOLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <srmJ8vMxKPH.A.2YB.JwhOLB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 29, 2009 at 04:28:54PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14905
> Subject		: kernel BUG at kernel/timer.c:951!
> Submitter	: Bernard Pidoux <bernard.pidoux@upmc.fr>
> Date		: 2009-12-19 13:38 (11 days old)
> References	: http://marc.info/?l=linux-kernel&m=126122997831460&w=4
> Handled-By	: Jarek Poplawski <jarkao2@gmail.com>
> 
> 

If this is what I think, then it's a "regular" bug, not a regression.

Jarek P.
