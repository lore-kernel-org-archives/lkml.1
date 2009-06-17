Return-Path: <linux-kernel-owner+w=401wt.eu-S1763482AbZFQK2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763482AbZFQK2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 06:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760933AbZFQK2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 06:28:07 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56654 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764195AbZFQK2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 06:28:05 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A38C533.3070106@s5r6.in-berlin.de>
Date: Wed, 17 Jun 2009 12:28:03 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090523 SeaMonkey/1.1.16
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org
CC: Matthew Wilcox <matthew@wil.cx>, Changli Gao <xiaosuo@gmail.com>,
       James.Bottomley@HansenPartnership.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SCSI: explain the hidden scsi_wait_scan Kconfig variable
References: <4A384FE4.9090703@gmail.com> <20090617021254.GQ19977@parisc-linux.org> <tkrat.ad6f8fb712020451@s5r6.in-berlin.de>
In-Reply-To: <tkrat.ad6f8fb712020451@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> People keep sending patches to expose CONFIG_SCSI_WAIT_SCAN as a tunable
> item.  These patches aren't accepted upstream, so let's stop the ongoing
> irritation of people due to this obscure and strange installed module
> and its Kconfig option.

PS, references:
http://bugzilla.kernel.org/show_bug.cgi?id=8763
http://bugzilla.kernel.org/show_bug.cgi?id=8872
http://bugzilla.kernel.org/show_bug.cgi?id=9769
and more mailinglist references than you can shake a stick at, yet 
nobody is aware of.
-- 
Stefan Richter
-=====-==--= -==- =---=
http://arcgraph.de/sr/
