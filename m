Return-Path: <linux-kernel-owner+w=401wt.eu-S937002AbXHHQsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937002AbXHHQsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761928AbXHHQr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:47:58 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:45024 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761895AbXHHQr5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:47:57 -0400
X-VirusChecked: Checked
X-Env-Sender: Scott_Kilau@digi.com
X-Msg-Ref: server-3.tower-29.messagelabs.com!1186591676!4483852!1
X-StarScan-Version: 5.5.12.11; banners=-,-,-
X-Originating-IP: [66.77.174.21]
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] jsm: Remove further unneeded crud
Date: Wed, 8 Aug 2007 11:47:54 -0500
Message-ID: <335DD0B75189FB428E5C32680089FB9F012DD53C@mtk-sms-mail01.digi.com>
In-reply-to: <20070808143849.7b970df1@the-village.bc.nu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] jsm: Remove further unneeded crud
thread-index: AcfZwGXqbK+KHNjOT66/u6QKIR/F+QAG02fA
References: <20070808143849.7b970df1@the-village.bc.nu>
From: "Kilau, Scott" <Scott_Kilau@digi.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, <akpm@osdl.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 08 Aug 2007 16:47:56.0047 (UTC) FILETIME=[DEAFB1F0:01C7D9DB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Remove some remaining vestiges of the old hacks jsm had to work around
> the old tty buffering. With the new tty buffering it simply doesn't
> matter any more.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

Thanks Alan for helping cleaning up jsm.

Acked-by: Scott Kilau <scottk@digi.com> 
