Return-Path: <linux-kernel-owner+w=401wt.eu-S1759009AbYERNQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759009AbYERNQO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 09:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbYERNQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 09:16:03 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:36772 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752399AbYERNQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 09:16:00 -0400
X-Sasl-enc: cz+VchGzMlwqkA1tfr5BbJxDwY7r/mQVo0BnZqLdkvzi 1211116559
Date: Sun, 18 May 2008 10:15:56 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Karol Lewandowski <lmctlx@gmail.com>
Subject: Re: [Bug #10670] BUG: linux-2.6.26-rc1 oops at
	thinkpad_acpi:led_set_status
Message-ID: <20080518131556.GA5517@khazad-dum.debian.net>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik> <7wuznNhcUqC.A.aT.ssBMIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7wuznNhcUqC.A.aT.ssBMIB@albercik>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 May 2008, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10670
> Subject		: BUG: linux-2.6.26-rc1 oops at thinkpad_acpi:led_set_status
> Submitter	: Karol Lewandowski <lmctlx@gmail.com>
> Date		: 2008-05-08 23:12 (11 days old)
> References	: http://marc.info/?l=linux-kernel&amp;m=121028841527994&amp;w=4
> 		  http://lkml.org/lkml/2008/5/12/12
> Handled-By	: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

Patch available, waiting for Len Brown to merge it.  Patch is also in
the bug report.

This bug causes an one byte memory corruption in the data segment on old
thinkpads.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
