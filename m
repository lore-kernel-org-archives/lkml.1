Return-Path: <linux-kernel-owner+w=401wt.eu-S1753750AbYIYFlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbYIYFlz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 01:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbYIYFlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 01:41:46 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50255 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752546AbYIYFlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 01:41:45 -0400
Subject: RE: [PATCH 1/6] bfa: Brocade BFA FC SCSI Driver submission
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jing Huang <huangj@Brocade.COM>
Cc: Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ramkumar Vadivelu <rvadivel@Brocade.COM>,
       Vinodh Ravindran <vravindr@Brocade.COM>,
       "Srikanth Rayas (CW)" <srayas@Brocade.COM>
In-Reply-To: <4C94DE2070B172459E4F1EE14BD2364E01F27D49@HQ-EXCH-5.corp.brocade.com>
References: <4C94DE2070B172459E4F1EE14BD2364E01F27D19@HQ-EXCH-5.corp.brocade.com>
	 <20080925044923.GA4310@kroah.com>
	 <1222319644.3602.1.camel@localhost.localdomain>
	 <4C94DE2070B172459E4F1EE14BD2364E01F27D49@HQ-EXCH-5.corp.brocade.com>
Content-Type: text/plain
Date: Wed, 24 Sep 2008 22:41:20 -0700
Message-Id: <1222321280.3602.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-24 at 22:33 -0700, Jing Huang wrote:
> Thanks James and Greg for the quick check on the patches.
> 
> I check the original patch, it is correct. I need to check the outlook
> setting to see how to prevent this issue.
> 
> This is my first time sending a patch, is there any trick to prevent
> line-wrap? I did send it using plain text and I tried to send to myself
> before sending to lkml, and I did't see this problem.
> 
> Sorry about the trouble.

Unfortunately, the remedy tends to be fairly specific to the email tool
you're using.  There's a helpful list of what to do here:

Documentation/email-clients.txt

but it's not exhaustive.

James


