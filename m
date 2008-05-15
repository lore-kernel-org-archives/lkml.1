Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbYEOTfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbYEOTfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbYEOTfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:35:25 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:55216 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751924AbYEOTfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:35:24 -0400
X-Sasl-enc: N2WFGEMpx9JmcEggDNkDb1Mw0DjSe7i5B/rP+9dvoDg6 1210880123
Date: Thu, 15 May 2008 16:35:21 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug #10670] BUG: linux-2.6.26-rc1 oops at
	thinkpad_acpi:led_set_status
Message-ID: <20080515193521.GA20976@khazad-dum.debian.net>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A.qfG.mv1JIB@chimera> <20080512041753.GA4543@khazad-dum.debian.net> <20080514233037.GB11439@cs181133002.pp.htv.fi> <20080515004911.GA3415@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515004911.GA3415@khazad-dum.debian.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch ready, tested by the bug submitter, and sent to Len Brown for
merging through the acpi-test tree.

A copy of the patch is also in the bugzilla report.

I will tag the report as CODE_FIX when Len accepts the patch, and close
the bugzilla report when the patch reaches mainline.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
