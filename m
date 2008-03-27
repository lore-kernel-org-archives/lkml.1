Return-Path: <linux-kernel-owner+w=401wt.eu-S1761441AbYC0VJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761441AbYC0VJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 17:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758443AbYC0VJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 17:09:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47231 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbYC0VJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 17:09:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: devzero@web.de
Subject: Re: acpi_ps_execute_method OOPS (Re: some minor issues with 2.6.25-rc6-git7-default)
Date: Thu, 27 Mar 2008 22:08:52 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <215112960@web.de>
In-Reply-To: <215112960@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803272208.53274.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 27 of March 2008, devzero@web.de wrote:
> > On Tuesday 25 March 2008, devzero@web.de wrote:
> > ...
> > > this one looks more serious (happened with modprobe -r ac),
> > > because kernel has problems afterwards (cannot load/anload any other module afterwards) 
> > 
> > any idea when this started happening?
> > Any chance you can snag the output from acpidump
> > and attach it to a sighting here?:
> > http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI
> > 
> > thanks,
> > -Len
> 
> i searched into this and found that it only happens after modprobe netsc520 ;modprobe -r netsc520.
> so maybe this is no acpi problem at all but corruption (sort of?) introduced by netsc520 module !?

What CPU/chipset is this?

Rafael
