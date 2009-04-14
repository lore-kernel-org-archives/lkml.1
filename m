Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbZDNSIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbZDNSIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739AbZDNSIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:08:30 -0400
Received: from ppp-111-110.adsl.restena.lu ([158.64.111.110]:48807 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580AbZDNSI3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:08:29 -0400
X-Greylist: delayed 660 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Apr 2009 14:08:29 EDT
Date: Tue, 14 Apr 2009 19:57:26 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: yakui_zhao <yakui.zhao@intel.com>
Cc: "Shi, Alex" <alex.shi@intel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Brown, Len" <len.brown@intel.com>
Subject: Re: 2.6.30-rc1 regression: boot hang due to commit
 ff69f2bba67bd45514923aaedbf40fe351787c59
Message-ID: <20090414195726.0244e6ba@neptune.home>
In-Reply-To: <1239669968.5564.51.camel@localhost.localdomain>
References: <20090413161101.0b3fc6f7@neptune.home>
	<1239669968.5564.51.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 April 2009 yakui_zhao <yakui.zhao@intel.com> wrote:
> On Mon, 2009-04-13 at 22:11 +0800, Bruno Prémont wrote:
> > Hi All,
> > 
> > I bisected a boot-hang on Acer TravelMate 66x laptop and ended on
> > commit ff69f2bba67bd45514923aaedbf40fe351787c59.
> Will you please add the boot option of "initcall_debug" and attach the
> screenshot where it hangs?
>    
> It will be great if you can file a new bug at
> http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI
> and attach the output of acpidump?
> Thanks.

Bug created as
  http://bugzilla.kernel.org/show_bug.cgi?id=13087

and includes complete boot log (until place where kernel hangs) as well
as acpidump output.

Bruno
