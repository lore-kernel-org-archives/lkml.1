Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933785Ab0BETJB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 14:09:01 -0500
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:39499 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756989Ab0BETJA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 14:09:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=tQKoBUo6elk/LaVdF2e9ioVCYhw2Ioc6hhmNMWnUlDSv4lovODjXucxVrk5+uofrcs75CHpSycimadG00/FS09mcfaELX3KfWrhsHq/LQCDBco4t1rY32dE/I2ihPmJf;
Date: Fri, 5 Feb 2010 11:08:11 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "=?UTF-8?B?SsOpcsOpbXk=?= Lal" <kapouer@melix.org>, rui.zhang@intel.com
Subject: Re: [Bug #15108] Blank screen with KMS enabled (on clevo M5xN
 laptop)
Message-ID: <20100205110811.16d64ded@jbarnes-piketon>
In-Reply-To: <de962C6zBxL.A.YOE.IFiZLB@chimera>
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera>
	<de962C6zBxL.A.YOE.IFiZLB@chimera>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  1 Feb 2010 01:43:21 +0100 (CET)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still
> should be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15108
> Subject		: Blank screen with KMS enabled (on clevo M5xN
> laptop) Submitter	: Jérémy Lal <kapouer@melix.org>
> Date		: 2010-01-22 20:30 (10 days old)

Looks like this one has a patch available.

Rui, is the patch upstream already?

-- 
Jesse Barnes, Intel Open Source Technology Center
