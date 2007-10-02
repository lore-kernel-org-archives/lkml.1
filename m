Return-Path: <linux-kernel-owner+w=401wt.eu-S1755062AbXJBIsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbXJBIsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 04:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbXJBIsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 04:48:10 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:44565
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752431AbXJBIsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 04:48:09 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] Add Documentation/power/00-INDEX
Date: Tue, 2 Oct 2007 03:48:03 -0500
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, rjw@sisk.pl
References: <200710012244.46869.rob@landley.net> <20071002071022.GA29559@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20071002071022.GA29559@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710020348.03470.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 October 2007 2:10:22 am Pavel Machek wrote:
> > +swsusp.txt
> > +	- Goals, implementation, and usage of software suspend (ACPI S3)
>
> But please delete (ACPI S3) remark. It is ACPI S4, if anything.
> 								Pavel

I got that from Documentation/power/video.txt, which starts "Video issues with 
S3 resume".  Is it correct in that file?

I've removed it from the patch in http://landley.net/kdocs/make/patches

Thanks,

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
