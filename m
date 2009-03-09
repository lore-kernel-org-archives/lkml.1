Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389AbZCISTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbZCISTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 14:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZCISTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 14:19:34 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:16122
	"EHLO WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751719AbZCISTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 14:19:33 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Mar 2009 14:19:33 EDT
X-BigFish: VPS-45(zz1432R98dR936eQ1805M936fK9371Pzzzzz2fh6bh62h)
X-Spam-TCS-SCL: 1:0
Message-ID: <49B55A21.2010801@am.sony.com>
Date: Mon, 9 Mar 2009 11:04:17 -0700
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Alessandro Zummo <alessandro.zummo@towertech.it>
CC: rtc-linux@googlegroups.com, Geert.Uytterhoeven@sonycom.com,
       Kyle McMartin <kyle@mcmartin.ca>, linux-parisc@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       Dann Frazier <dannf@dannf.org>
Subject: Re: [rtc-linux] [PATCH 7/7] powerpc/ps3: Add rtc-ps3
References: <1236605183-22718-1-git-send-email-Geert.Uytterhoeven@sonycom.com>	<1236605183-22718-2-git-send-email-Geert.Uytterhoeven@sonycom.com>	<1236605183-22718-3-git-send-email-Geert.Uytterhoeven@sonycom.com>	<1236605183-22718-4-git-send-email-Geert.Uytterhoeven@sonycom.com>	<1236605183-22718-5-git-send-email-Geert.Uytterhoeven@sonycom.com>	<1236605183-22718-6-git-send-email-Geert.Uytterhoeven@sonycom.com>	<1236605183-22718-7-git-send-email-Geert.Uytterhoeven@sonycom.com>	<1236605183-22718-8-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090309151216.17f13862@i1501.lan.towertech.it>
In-Reply-To: <20090309151216.17f13862@i1501.lan.towertech.it>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Mar 2009 18:04:18.0078 (UTC) FILETIME=[76F763E0:01C9A0E1]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/09/2009 07:12 AM, Alessandro Zummo wrote:
> On Mon,  9 Mar 2009 14:26:23 +0100
> Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
>> +
>> +MODULE_AUTHOR("Sony Corporation");
> 
>  real name, if possible and a contact address
>  here . Just in case I need someone to bother :)

Please look at the MAINTAINERS file, that will give
the contact for PS3.  It is much easier to maintain
a single place for the contact than many spread
throughout the kernel sources.

-Geoff

