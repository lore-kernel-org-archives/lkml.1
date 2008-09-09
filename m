Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbYIIFCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbYIIFCG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 01:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbYIIFBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 01:01:55 -0400
Received: from outbound-mail-124.bluehost.com ([67.222.38.24]:36112 "HELO
	outbound-mail-124.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751183AbYIIFBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 01:01:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=S+XZApnR0veXv7WRBtA8muwXSHWoFe836qA1hHiT9lrNr4ln1trC5ab03uwaqod2E9jmm2nhtFEMWZ9aX3Ez2TDZG440lU/yg+K4Y86ZPd7AVOUNU5/0Tn9OIUnVsr3q;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg KH <gregkh@suse.de>
Subject: Re: [Bug #11439] [2.6.27-rc4-git4] compilation warnings
Date: Mon, 8 Sep 2008 22:01:46 -0700
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rufus &amp; Azrael" <rufus-azrael@numericable.fr>
References: <s3QDdfEDq6.A.wlH.MowwIB@albercik> <Wz8EH5sroeE.A.W7.LpwwIB@albercik> <20080908044424.GB4052@suse.de>
In-Reply-To: <20080908044424.GB4052@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809082201.46250.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 12.108.5.2 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, September 07, 2008 9:44 pm Greg KH wrote:
> On Sat, Sep 06, 2008 at 11:30:42PM +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11439
> > Subject		: [2.6.27-rc4-git4] compilation warnings
> > Submitter	: Rufus &amp; Azrael <rufus-azrael@numericable.fr>
> > Date		: 2008-08-26 9:37 (12 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121974353815440&w=4
> > Handled-By	: Greg KH <gregkh@suse.de>
> > Patch		: http://marc.info/?l=linux-kernel&m=121976424221858&w=4
>
> Jesse, have you queued up this patch to send to Linus for 2.6.27?

Not yet; I'll include it in my next pull request though.

Thanks,
Jesse
