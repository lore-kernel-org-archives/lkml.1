Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbZJGXpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbZJGXpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 19:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756464AbZJGXpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 19:45:12 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:38996
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753873AbZJGXpL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 19:45:11 -0400
X-SpamScore: -30
X-BigFish: VPS-30(zz542N1432R98dN9371Pzz1202hzzz2dh6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: Xilinx SYSACE driver and 8-bit attachment
Date: Wed, 7 Oct 2009 17:44:18 -0600
In-Reply-To: <1d3f23370910071641s75b2d217h71a839b1a0b4013c@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Xilinx SYSACE driver and 8-bit attachment
Thread-Index: AcpHp9rfcZ7r2AadTFehPvaQfutxTwAABDPg
References: <1d3f23370910070013u6307bc42hf7ab243b52d007df@mail.gmail.com> <fa686aa40910070634r4a8dcf74qdcbfb3bde3413109@mail.gmail.com> <838c3c32-27d9-4a0a-a197-c7227b911942@VA3EHSMHS014.ehs.local> <1d3f23370910071641s75b2d217h71a839b1a0b4013c@mail.gmail.com>
From: John Linn <John.Linn@xilinx.com>
To: "John Williams" <john.williams@petalogix.com>
CC: <grant.likely@secretlab.ca>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Michal Simek" <michal.simek@petalogix.com>,
       "David DeBonis" <ddeboni@xilinx.com>,
       "Stephen Neuendorffer" <stephenn@xilinx.com>,
       "devicetree-discuss" <devicetree-discuss@lists.ozlabs.org>
X-OriginalArrivalTime: 07 Oct 2009 23:44:20.0465 (UTC) FILETIME=[174F9610:01CA47A8]
Message-ID: <7a2a686d-ddf4-4a42-8c73-c933cebf22a4@VA3EHSMHS005.ehs.local>
X-Reverse-DNS: unknown-60-83.xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed the device tree generator and checked into git-dev, I'll push it out soon after a little more test time.

-- John

> -----Original Message-----
> From: John Williams [mailto:john.williams@petalogix.com]
> Sent: Wednesday, October 07, 2009 5:42 PM
> To: John Linn
> Cc: grant.likely@secretlab.ca; Linux Kernel list; Michal Simek; David DeBonis; Stephen Neuendorffer;
> devicetree-discuss
> Subject: Re: Xilinx SYSACE driver and 8-bit attachment
> 
> Hi John,
> 
> On Thu, Oct 8, 2009 at 12:24 AM, John Linn <John.Linn@xilinx.com> wrote:
> > I'll look to see if something has changed.  It's not clear to me if it has ever been right.
> >
> > It look like we normally use 16 bit mode as that's how BSB generates the system by default.
> 
> The SP605 reference design uses an 8-bit attachment to the SystemACE -
> that's how I found this issue.
> 
> John
> --
> John Williams, PhD, B.Eng, B.IT
> PetaLogix - Linux Solutions for a Reconfigurable World
> w: www.petalogix.com  p: +61-7-30090663  f: +61-7-30090663


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


