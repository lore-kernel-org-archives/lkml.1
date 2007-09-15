Return-Path: <linux-kernel-owner+w=401wt.eu-S932252AbXIOGRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252AbXIOGRU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 02:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbXIOGRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 02:17:10 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59720 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbXIOGRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 02:17:08 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46EB78A3.9050404@s5r6.in-berlin.de>
Date: Sat, 15 Sep 2007 08:16:03 +0200
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
References: <20070914202102.GE5386@csclub.uwaterloo.ca>	<tkrat.f4379d6e5f1ce499@s5r6.in-berlin.de>	<tkrat.0e73b94c1e80a481@s5r6.in-berlin.de> <20070914031256T.tomof@acm.org>
In-Reply-To: <20070914031256T.tomof@acm.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Fri, 14 Sep 2007 23:14:21 +0200 (CEST)
> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
...
>> And one more update:
>> There is SAS too,
...
>> +	  You need it
>> +	  - for classic parallel SCSI hardware,
>> +	  - for newer SCSI transports such as Fibre Channel, FireWire storage,
>> +	    SAS, or iSCSI,
> 
> There is SRP too.

I think I'll rewrite it as "for newer SCSI transports such as FireWire
storage."  ;-)

If SRP was in, can 'such as' be omitted?  "for newer SCSI transports
(Fibre Channel, FireWire storage, iSCSI, SAS, SRP),"  Or would be "for
newer SCSI transports such as Fibre Channel, FireWire storage, iSCSI,
SAS, and more," be OK?
-- 
Stefan Richter
-=====-=-=== =--= -====
http://arcgraph.de/sr/
