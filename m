Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbYBNP7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbYBNP7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:59:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbYBNP7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:59:45 -0500
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:27459 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753011AbYBNP7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:59:44 -0500
Message-ID: <47B46513.8020206@panasas.com>
Date: Thu, 14 Feb 2008 17:58:11 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Stefan Priebe - allied internet ag <s.priebe@allied-internet.ag>,
       =?ISO-8859-1?Q?Sven_K=F6hler?= <skoehler@upb.de>,
       Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel@vger.kernel.org, Joerg Dorchain <joerg@dorchain.net>,
       Jon Chelton <jchelton@ffpglobal.com>
Subject: Re: [BUGFIX 2/2] gdth: bugfix for the Timer at exit crash
References: <fnqka6$l46$1@ger.gmane.org> <47A19E26.30107@panasas.com> <47B1D7A8.8010108@panasas.com> <47B1DA2A.1060904@panasas.com> <47B29702.7050503@allied-internet.ag> <47B2B268.1070702@panasas.com> <Pine.LNX.4.64.0802132038320.29154@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0802132038320.29154@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Feb 2008 15:58:52.0079 (UTC) FILETIME=[7E6E53F0:01C86F22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13 2008 at 21:38 +0200, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> On Feb 13 2008 11:03, Boaz Harrosh wrote:
>>> I've tested this patch now - and it works fine. Now rmmod, halt and 
>>> reboot also works.
>>>
>>> Stefan Priebe
>>>
>> This is grate news Stefan. Thank you very much for all your time
>> and effort, with out we could not have fixed all this.
> 
> Do you have a git tree with the latest pieces?
No, scsi-misc I guess ;)

I could put it here:
git://git.bhalevy.com/open-osd gdth

branch give me an hours

Boaz
