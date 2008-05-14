Return-Path: <linux-kernel-owner+w=401wt.eu-S1759948AbYENIwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759948AbYENIwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 04:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbYENIwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 04:52:04 -0400
Received: from mail153.messagelabs.com ([216.82.253.51]:63126 "HELO
	mail153.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751658AbYENIwB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 04:52:01 -0400
X-VirusChecked: Checked
X-Env-Sender: HRX378@motorola.com
X-Msg-Ref: server-7.tower-153.messagelabs.com!1210755120!6384606!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [129.188.136.8]
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: memory corruption issues in wait_table of zone"DMA"
Date: Wed, 14 May 2008 16:51:55 +0800
Message-ID: <B23AF77AA6CA8E458CC272CE0D0CB2FE020FA98D@zmy16exm62.ds.mot.com>
In-Reply-To: <1210754366.4650.5.camel@dhcp-lab-164.englab.brq.redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: memory corruption issues in wait_table of zone"DMA"
thread-index: Aci1nc2q9llVqER/QkOuHCKs0B/3NgAADXYw
References: <1210754366.4650.5.camel@dhcp-lab-164.englab.brq.redhat.com>
From: "ZHANG XIAO-QIN-HRX378" <HRX378@motorola.com>
To: "Jan Lieskovsky" <jlieskov@redhat.com>
Cc: <linux-kernel@vger.kernel.org>, "Ma Maggie-VBHM46" <VBHM46@motorola.com>
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi Jan,

Thanks for your reply.

These memory corruption issue just happened during kernel bootup(less
than 2 secs).The kernel version is 2.6.10.And it is embeded linux
system(arm),only one zone in this system that is "DMA".

Thanks

Belinda

-----Original Message-----
From: Jan Lieskovsky [mailto:jlieskov@redhat.com] 
Sent: Wednesday, May 14, 2008 4:39 PM
To: ZHANG XIAO-QIN-HRX378
Subject: Re: memory corruption issues in wait_table of zone"DMA"

Hello Zhang,

  have noticed your above post
(
http://groups.google.com/group/linux.kernel/browse_thread/thread/d336c86
49f3bf136?hl=en# ).

Could you please provide more details about the steps you are performing
to cause these types of memory corruptions? Or is it only regression
from previous kernel releases? Is this issue triggerable by a normal
Linux unprivileged user (i.e. could it be a security issue -- misused by
normal Linux user to force memory/cpu/DMA corruption)?

Any more details would be appreciated

Thank you for your time!

Kind regards
Jan iankko Lieskovsky
RH kernel Security Response Team

