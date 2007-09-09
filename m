Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbXIIChl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbXIIChl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 22:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbXIIChd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 22:37:33 -0400
Received: from mail98.megamailservers.com ([216.251.36.98]:43909 "EHLO
	mail98.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750717AbXIIChc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 22:37:32 -0400
X-Authenticated-User: jgeorgas.georgas.ca
Subject: Re: broken ACPI NUMA config option
From: "James C. Georgas" <jgeorgas@georgas.ca>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Georgas Software Solutions
Date: Sat, 08 Sep 2007 22:36:48 -0400
Message-Id: <1189305408.13467.54.camel@Tachyon.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-08-09 at 18:16 -0700, Randy Dunlap wrote:
> On Sat, 8 Sep 2007 18:09:04 -0700 Randy Dunlap wrote:
> 
> > On Sat, 08 Sep 2007 18:51:39 -0400 James C. Georgas wrote:
> > 
> > > If I select X86_64_ACPI_NUMA, then ACPI_NUMA is (properly)
selected
> > > automatically, but ACPI is not selected automatically. This causes
> > > ACPI_NUMA to not be built, and the kernel compile fails with
unresolved
> > > symbols.
> > 
> > exactly what kernel version??
> > 
> 
> 2.6.23-rc5-git1 builds for me when I follow those steps...
> except for some Section mismatch warnings.

What is the git project path name for the 2.6.23rc branch, if I wanted
to clone it, to keep up to date?

James
	/\V

