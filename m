Return-Path: <linux-kernel-owner+w=401wt.eu-S1757797AbYKVL0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797AbYKVL0o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 06:26:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756967AbYKVL0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 06:26:35 -0500
Received: from phoenix.slamd64.com ([217.10.145.2]:38051 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880AbYKVL0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 06:26:34 -0500
X-Greylist: delayed 846 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Nov 2008 06:26:33 EST
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] ACPI suspend: Blacklist HP xw4600 Workstation for old code ordering
Date: Sat, 22 Nov 2008 11:11:49 +0000
User-Agent: KMail/1.10.1 (Linux/2.6.27; KDE/4.1.2; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, John Brown <john.brown3@hp.com>
References: <200810142254.07024.rjw@sisk.pl> <20081015141526.GA5633@srcf.ucam.org> <200810152320.06167.rjw@sisk.pl>
In-Reply-To: <200810152320.06167.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200811221111.50952.carlos@strangeworlds.co.uk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Sat, 22 Nov 2008 11:11:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 October 2008 22:20:05 Rafael J. Wysocki wrote:
> > > IOW, we aren't doing anything wrong and the BIOS is buggy.
> >
> > So how does Windows cope with this?
>
> I don't know. :-(
>
> One possible explanation is that the device causing the trouble is not put
> into D3 at all during suspend, but I'm speculating here.

Do we know which device it is that causes the trouble on this HP box?

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D

