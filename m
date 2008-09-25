Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbYIYGT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbYIYGT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 02:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbYIYGTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 02:19:47 -0400
Received: from mx10.brocade.com ([208.185.105.18]:58195 "EHLO mx10.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbYIYGTq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 02:19:46 -0400
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Sep 2008 02:19:45 EDT
X-IronPort-AV: E=Sophos;i="4.33,306,1220252400"; 
   d="scan'208";a="126917787"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/6] bfa: Brocade BFA FC SCSI Driver submission
Date: Wed, 24 Sep 2008 23:09:54 -0700
Message-ID: <4C94DE2070B172459E4F1EE14BD2364E01F27D54@HQ-EXCH-5.corp.brocade.com>
In-Reply-To: <20080925055725.GC66712@sgi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/6] bfa: Brocade BFA FC SCSI Driver submission
Thread-Index: Acke05cekC7R5tnRQ4GO+x/93yESZwAAGKfA
References: <4C94DE2070B172459E4F1EE14BD2364E01F27D19@HQ-EXCH-5.corp.brocade.com> <20080925044923.GA4310@kroah.com> <1222319644.3602.1.camel@localhost.localdomain> <4C94DE2070B172459E4F1EE14BD2364E01F27D49@HQ-EXCH-5.corp.brocade.com> <20080925055725.GC66712@sgi.com>
From: "Jing Huang" <huangj@Brocade.COM>
To: "Jeremy Higdon" <jeremy@sgi.com>
Cc: "James Bottomley" <James.Bottomley@HansenPartnership.com>,
       "Greg KH" <greg@kroah.com>, <linux-scsi@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>,
       "Ramkumar Vadivelu" <rvadivel@Brocade.COM>,
       "Vinodh Ravindran" <vravindr@Brocade.COM>,
       "Srikanth Rayas (CW)" <srayas@Brocade.COM>
X-OriginalArrivalTime: 25 Sep 2008 06:10:13.0226 (UTC) FILETIME=[5F490CA0:01C91ED5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

I looked at Documentation/email-clients.txt. There is no info about
outlook. So I believe Jeremy is right. 

Is attachment acceptable for my first submission? Meanwhile I will find
out if I can use other email client in my company.

Jing

-----Original Message-----
From: Jeremy Higdon [mailto:jeremy@sgi.com] 
Sent: Wednesday, September 24, 2008 10:57 PM
To: Jing Huang
Cc: James Bottomley; Greg KH; linux-scsi@vger.kernel.org;
linux-kernel@vger.kernel.org; Ramkumar Vadivelu; Vinodh Ravindran;
Srikanth Rayas (CW)
Subject: Re: [PATCH 1/6] bfa: Brocade BFA FC SCSI Driver submission

On Wed, Sep 24, 2008 at 10:33:26PM -0700, Jing Huang wrote:
> Thanks James and Greg for the quick check on the patches.
> 
> I check the original patch, it is correct. I need to check the outlook
> setting to see how to prevent this issue.
> 
> This is my first time sending a patch, is there any trick to prevent
> line-wrap? I did send it using plain text and I tried to send to
myself
> before sending to lkml, and I did't see this problem.


The fix is not to use Outlook -- I've never known anyone to be able
to get it not to mangle email.  If you're stuck with that, try attaching
the patch as a text document, if that's acceptable to James.

I know someone that uses mutt on Windows, and it seems to work fine.

jeremy
