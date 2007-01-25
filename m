Return-Path: <linux-kernel-owner+w=401wt.eu-S965717AbXAYJDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965717AbXAYJDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 04:03:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965719AbXAYJDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 04:03:38 -0500
Received: from mclmx2.mail.saic.com ([149.8.64.32]:58392 "EHLO
	mclmx2.mail.saic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965717AbXAYJDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 04:03:35 -0500
Subject: Re: IO-APIC + timer doesn't work - 2.6.20-rc5 on abit KN9-Ultra b
	ios 1.6
From: Eamonn Hamilton <EAMONN.HAMILTON@saic.com>
To: Luming Yu <luming.yu@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <3877989d0701242133v2d554d45j603af0b597085fb9@mail.gmail.com>
References: <3877989d0701242133v2d554d45j603af0b597085fb9@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 25 Jan 2007 09:03:02 +0000
Message-Id: <1169715782.22508.202.camel@ukabzc383.uk.saic.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Content-Transfer-Encoding: 7bit
X-ukabzc383-MailScanner: Found to be clean
X-ukabzc383-MailScanner-From: eamonn.hamilton@saic.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I didn't get a chance to try the -mm patch, but booting with acpi=off
works - other than no acpi, of course :)

What now?

Cheers,
Eamonn

On Thu, 2007-01-25 at 05:33 +0000, Luming Yu wrote:
> On 1/25/07, Eamonn Hamilton <EAMONN.HAMILTON@saic.com> wrote:
> > I've also just found bug #7820 on bugzilla which has a patch which may
> > address this issue from Ingo.
> >
> > I'll give that a shot as well.
> >
> 
> Yes, that patch workaround the problem. But it is just a workaround.
> It would be much helpful to others by fixing the original problem.


-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

