Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbZHZWB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbZHZWB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 18:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754055AbZHZWB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 18:01:57 -0400
Received: from static-76-164-182-57.apid.com ([76.164.182.57]:60758 "EHLO
	waltsputer.localdomain" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754008AbZHZWB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 18:01:56 -0400
Date: Wed, 26 Aug 2009 17:01:51 -0500 (CDT)
From: Walt Holman <walt@holmansrus.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <775912665.01251324111901.JavaMail.root@mail.holmansrus.com>
In-Reply-To: <200908262312.04000.rjw@sisk.pl>
Subject: Re: [Bug #14057] Strange network timeouts w/ e100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.0.1]
X-Mailer: Zimbra 6.0.0_RC1_1684.UBUNTU8_64 (ZimbraWebClient - [unknown] (Linux)/6.0.0_RC1_1684.UBUNTU8_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Wednesday 26 August 2009, Walt Holman wrote:
> > 
> > ----- "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > This message has been generated automatically as a part of a
> report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known
> regressions
> > > from 2.6.30.  Please verify if it still should be listed and let
> me
> > > know
> > > (either way).
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14057
> > > Subject		: Strange network timeouts w/ e100
> > > Submitter	: Walt Holman <walt@holmansrus.com>
> > > Date		: 2009-08-20 0:21 (6 days old)
> > > References	:
> http://marc.info/?l=linux-kernel&m=125072831831443&w=4
> > > Handled-By	: Krzysztof Halasa <khc@pm.waw.pl>
> > 
> > Hi Rafael,
> 
> Hi,
> 
> > Krzysztof has a patch which has corrected this issue for me. 
> Thanks,
> 
> Thanks for the update.
> 
> Do you have a pointer to the patch, please?
> 
> Rafael

Yes, it's referenced in:

http://marc.info/?l=linux-netdev&m=125104144706982&w=2

Which was for 2.6.30.5  The same patch still applies on 2.6.31-rc7 with offset and that's actually where I tested it.  That resolved the timeouts for me.  I believe Krzysztof was going to get a patch in to -stable as well as for .31-rc before final.

-Walt

