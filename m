Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbXJIVJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbXJIVJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 17:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbXJIVJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 17:09:50 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:40878 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751105AbXJIVJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 17:09:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=xrsRmpd0b9RauPfSksNcFxInZnmHFuzeRJNHEZ8XeU/Yui5rNuPHDll4zlfVPOlL04KcxE3DJ5NpEQKWn0uVrHFAhLjpHRrmOrV6FVPGZIuHE/uj+Pd37x3M2wCTabHEbRhp0vHQl5HEOBTpuqjqMg0weIjkyuA7OtfQ7Ky5yaQ=  ;
X-YMail-OSG: CZArO28VM1n.PF.CMSf1e6iGwcNeMq09woorOJUU2DfA6unOk.mks7Ch1e1uLv.75q7gKZcltw--
Date: Tue, 09 Oct 2007 14:09:55 -0700
From: David Brownell <david-b@pacbell.net>
To: davem@davemloft.net
Subject: Re: OHCI root_port_reset() deadly loop...
Cc: linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       greg@kroah.com
References: <20071009043643.773CC23715F@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <20071008.214408.98397070.davem@davemloft.net>
 <20071009163827.E7DB310B535@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <20071009.134116.63997473.davem@davemloft.net>
In-Reply-To: <20071009.134116.63997473.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071009210955.01668236A37@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Even though I'm severly overloaded, you asked me for a patch, I gave
> you one.

And I got some questions as I reviewed it.  That's far
from un-heard-of.  One particular question related to
one potential simplification ... which unfortunately
couldn't check out.  Also not un-heard-of.


>	And now you want to push it back at me because it isn't
> clear to you yet that the code there right now is a huge problem.

You're reading things into what I wrote which were not there.
Calm down.

- Dave

