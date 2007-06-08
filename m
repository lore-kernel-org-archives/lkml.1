Return-Path: <linux-kernel-owner+w=401wt.eu-S970749AbXFHSck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970749AbXFHSck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765745AbXFHSca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:32:30 -0400
Received: from mail-gw3.adaptec.com ([216.52.22.36]:51602 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758448AbXFHSc3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:32:29 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [stable] [patch 37/54] SCSI: aacraid: Correct saplatformsupport. (Was: [Bug 8469] Bad EIP value on pentium3SMPkernel-2.6.21.1)
Date: Fri, 8 Jun 2007 14:32:27 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01AB8574@otce2k301.adaptec.com>
In-reply-to: <20070608182917.GI3723@sequoia.sous-sol.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [stable] [patch 37/54] SCSI: aacraid: Correct saplatformsupport. (Was: [Bug 8469] Bad EIP value on pentium3SMPkernel-2.6.21.1)
Thread-Index: Acep+u5fZXrkUH9GSFu11fFX0+Z/1gAAEa5Q
From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
To: "Chris Wright" <chrisw@sous-sol.org>
Cc: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>,
       "James Bottomley" <James.Bottomley@steeleye.com>,
       "AACRAID" <aacraid@adaptec.com>, "Greg Kroah-Hartman" <gregkh@suse.de>,
       <linux-kernel@vger.kernel.org>, <stable@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Drop the setting of restart, drop the dummy restart handler in sa.c.

I will send you what I mean later when I have time ...

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Chris Wright [mailto:chrisw@sous-sol.org] 
> Sent: Friday, June 08, 2007 2:29 PM
> To: Salyzyn, Mark
> Cc: Chris Wright; Stefan Lippers-Hollmann; James Bottomley; 
> AACRAID; Greg Kroah-Hartman; linux-kernel@vger.kernel.org; 
> stable@kernel.org
> Subject: Re: [stable] [patch 37/54] SCSI: aacraid: Correct 
> saplatformsupport. (Was: [Bug 8469] Bad EIP value on 
> pentium3SMPkernel-2.6.21.1)
> 
> 
> * Salyzyn, Mark (mark_salyzyn@adaptec.com) wrote:
> > Yes, split the patch into the two pieces for 2.6.21.1/2.6.21.4
> 
> Sorry, didn't parse.  Are you suggesting to use the patch I included
> (which simply drops the ->adapter_restart init), or the original patch
> plus Mark Havercamp's patch to add ->adapter_restart?
> 
> thanks,
> -chris
> 
