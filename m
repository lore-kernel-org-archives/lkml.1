Return-Path: <linux-kernel-owner+w=401wt.eu-S1762866AbYHFJ3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762866AbYHFJ3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 05:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbYHFJ3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 05:29:24 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:47455 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754227AbYHFJ3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 05:29:24 -0400
In-Reply-To: <1217965563.27684.159.camel@localhost.localdomain>
To: Eric Paris <eparis@redhat.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface	for on
 access scanning
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: tvrtko.ursulin@sophos.com
Date: Wed, 6 Aug 2008 10:28:24 +0100
X-MIMETrack: S/MIME Sign by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 06/08/2008 10:29:12,
	Serialize by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 06/08/2008 10:29:12,
	Serialize complete at 06/08/2008 10:29:12,
	S/MIME Sign failed at 06/08/2008 10:29:12: The cryptographic key was not
 found,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 06/08/2008 10:28:34,
	Serialize complete at 06/08/2008 10:28:34
Content-Type: text/plain; charset="US-ASCII"
Message-Id: <20080806092926.79138316AA1@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote on 05/08/2008 20:46:03:

> On Mon, 2008-08-04 at 17:51 -0700, Greg KH wrote:
> > On Mon, Aug 04, 2008 at 08:32:54PM -0400, Eric Paris wrote:
> 
> > Oh, and after that, not using a binary interface, have we not learned
> > from the ioctl mess?  I sure thought we had...
> 
> I don't see a reason why we can't use strings and key=value pairs for
> any metadata being sent back and forth.  That seem more reasonable?

Should be OK from my point of view assuming we keep cache and basic 
filesystem exclusions in kernel. Otherwise it would be too much work (I am 
talking about CPU time) to do with each and every interception.

Tvrtko


Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

