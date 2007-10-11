Return-Path: <linux-kernel-owner+w=401wt.eu-S1757295AbXJKQun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbXJKQun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 12:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113AbXJKQuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 12:50:25 -0400
Received: from mlbe2k2.cs.myharris.net ([137.237.90.89]:21365 "EHLO
	mlbe2k2.cs.myharris.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869AbXJKQuY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 12:50:24 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: Aggregation in embedded context, is kernel GPL2prejudiceagainst embedded systems?
Date: Thu, 11 Oct 2007 12:49:42 -0400
Message-ID: <E496871456016F4CA8959BE4105D2A890E8D7E@troe2k1.cs.myharris.net>
In-Reply-To: <20071011162219.GI10759@thunk.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Aggregation in embedded context, is kernel GPL2prejudiceagainst embedded systems?
Thread-Index: AcgMItdAZH2pKeDYTrisB+eSJ+JjpgAArfyQ
References: <E496871456016F4CA8959BE4105D2A890E8D76@troe2k1.cs.myharris.net> <20071011151543.GX16424@stusta.de> <E496871456016F4CA8959BE4105D2A890E8D7C@troe2k1.cs.myharris.net> <20071011162219.GI10759@thunk.org>
From: "Crane, Matthew" <mcrane03@harris.com>
To: "Theodore Tso" <tytso@mit.edu>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 11 Oct 2007 16:49:44.0235 (UTC) FILETIME=[B99BDFB0:01C80C26]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

So really, the only way for a company to know if they are ok would be to
sue themselves in a test case and force the issue.  This would at least
set some precedent and help remove some of the FUD around the issue.  I
have no idea about the details, but it seems that those groups who have
pursued GPL cases may have avoided setting precedents lest it reduce the
grayness.  I can easily imagine constructing a generic system that can
be used as a solid test and provide technical and legal reference for
others, once it has been ruled on in one or more courts.

Matt


-----Original Message-----
From: Theodore Tso [mailto:tytso@mit.edu] 
Sent: Thursday, October 11, 2007 12:22 PM
To: Crane, Matthew
Cc: Adrian Bunk; linux-kernel@vger.kernel.org
Subject: Re: Aggregation in embedded context, is kernel
GPL2prejudiceagainst embedded systems?

On Thu, Oct 11, 2007 at 12:06:14PM -0400, Crane, Matthew wrote:
> I wasn't sure how to describe what the people and groups with the
> mandate to defend open source software.  There are people and groups
> with such a mandate.

There is no such thing as "mandate".  If you are a copyright owner,
and you elect to be a hard*ss about enforcing the GPL, you can choose
to do so.  If you are not a copyright owner, all you can do is
pontificate with FAQ's about GPL....

> I'm asking if in a legal sense the grayness is affected by the
> constraints of the hw the kernel is being run on, and some attempt to
> quantify how the grayness is affected.  Of course it is not black and
> white and ultimately up to a judge. 

At the end of the day it all boils down to what is a derived work.  If
an object file which is designed to link into a kernel is a derived
work, then the GPL claims that it will infect across to that derived
work.  Whether or not it this is a case is a matter of much debate,
and as far as I know, no court has ever ruled on point regarding the
question of object files, dynamical linking, and whether or not that
would be a derived work or not.  It seems likely that the answer may
vary from one legal jurisdiction to another.  Hence, the only answer
that we can give which is useful is, "Take this off of LKML, and go
ask a lawyer."

Best regards,

						- Ted
