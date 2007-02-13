Return-Path: <linux-kernel-owner+w=401wt.eu-S1751090AbXBMVkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751090AbXBMVkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 16:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbXBMVkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 16:40:41 -0500
Received: from smtp.bulldogdsl.com ([212.158.248.8]:1050 "EHLO
	mcr-smtp-002.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751090AbXBMVkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 16:40:40 -0500
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Subject: Re: User tools for March 11
Date: Tue, 13 Feb 2007 21:40:39 +0000
User-Agent: KMail/1.9.5
Cc: "Linux kernel" <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.61.0702131607590.27065@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.61.0702131607590.27065@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702132140.39967.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 February 2007 21:19, linux-os (Dick Johnson) wrote:
> Hi!
> In the United States, some idiots have decided that the year 2000 scare
> wasn't enough so they changed the start date for daylight savings time
> from the first Sunday in April to the second Sunday in March.
> Does anybody know if there are new tools like `hwclock` and `date`?
> Will new 'C' runtime libraries be necessary as well?

Unless there are utilities homebrewing locales, glibc (locales) should be the 
only package that requires an update. Some distros may sub-package this 
as "timezone".

SLES got an updated "timezone" package for the Western Australian changes, but 
I'm not sure about the US changes.

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
