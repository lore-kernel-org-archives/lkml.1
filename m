Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbXIOMb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbXIOMb2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 08:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbXIOMbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 08:31:20 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38219 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbXIOMbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 08:31:19 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46EBD052.9090608@s5r6.in-berlin.de>
Date: Sat, 15 Sep 2007 14:30:10 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: FUJITA Tomonori <tomof@acm.org>
CC: lsorense@csclub.uwaterloo.ca, james.bottomley@steeleye.com,
       linux-scsi@vger.kernel.org, jeff@garzik.org, andi@firstfloor.org,
       folkert@vanheusden.com, bunk@kernel.org, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH update] SCSI: update Kconfig help text to indicate SCSI
 core's widespread usage
References: <tkrat.0e73b94c1e80a481@s5r6.in-berlin.de>	<20070914031256T.tomof@acm.org>	<46EB78A3.9050404@s5r6.in-berlin.de> <20070914114042M.tomof@acm.org>
In-Reply-To: <20070914114042M.tomof@acm.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Sat, 15 Sep 2007 08:16:03 +0200
> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> Or would be "for newer SCSI transports such as Fibre Channel,
>> FireWire storage, iSCSI, SAS, and more," be OK?
> 
> scsi-ml has SPI, FC, iSCSI, SAS, and SRP transport classes (SRP is in
> scsi-misc now). It's a bit strange to omit only SRP, I think. But I
> might be too SRP-biased.

"such as... and more" suggests that there are indeed more SCSI
transports supported by Linux than mentioned in this help text.

We could also write "such as Fibre Channel, iSCSI, SAS, and more," if
you suspect bias on my side. ;-)  Help texts should be concise.
-- 
Stefan Richter
-=====-=-=== =--= -====
http://arcgraph.de/sr/
