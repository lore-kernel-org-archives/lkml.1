Return-Path: <linux-kernel-owner+w=401wt.eu-S1758654AbZKYK5C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbZKYK5C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 05:57:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758592AbZKYK5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 05:57:00 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:46675 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758527AbZKYK45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 05:56:57 -0500
Date: Wed, 25 Nov 2009 12:56:49 +0200
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
       List Linux Kernel <linux-kernel@vger.kernel.org>
Subject: ALS subsystem (was Re: [PATCH 1/2] staging: iio: tsl2563 ambient
 light sensor driver)
Message-ID: <20091125105649.GJ16444@smtp.gmail.com>
Mail-Followup-To: Zhang Rui <rui.zhang@intel.com>,
	Jonathan Cameron <jic23@cam.ac.uk>,
	List Linux Kernel <linux-kernel@vger.kernel.org>
References: <1257772468-4004-1-git-send-email-amit.kucheria@verdurent.com>
 <4AF81FE5.5080102@cam.ac.uk>
 <20091109142430.GZ1773@smtp.gmail.com>
 <4AF85ABB.7060406@cam.ac.uk>
 <1257843493.4469.25.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1257843493.4469.25.camel@rzhang-dt>
X-URL: http://www.verdurent.com/
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09 Nov 10, Zhang Rui wrote:
> On Tue, 2009-11-10 at 02:08 +0800, Jonathan Cameron wrote:
> > Amit Kucheria wrote:
> > > On 09 Nov 09, Jonathan Cameron wrote:
> > >> Hi Amit,
> > >>
> > >> Normally I'd welcome this in IIO, except that all ambient light sensors are in the
> > >> process of moving to the new ALS subsystem.  There are still some issues to resolve
> > >> in that subsystem (mainly to do with naming conventions) but hopefully we will
> > >> get them sorted out shortly.
> > > 
> > > Groan! :)
> > You have my sympathies on this! Typical that the first other developer to put
> > forward a patch for IIO picks the one type of device we are moving out.
> > If you do have any comments on IIO as a result of using it please send them
> > on.
> > > Who will be the subsystem maintainer and is there already a public git
> > > tree?
> > No git tree as far as I know.  Maintainer is Zhang Rui (Cc'd)
> > Zhang, what are your plans wrt to that?  I guess I can put one up with the current
> > patches if it is helpful?  We really need to sort out the naming issue as the one
> > thing that people have come out against. 
> > 
> well. I'd prefer a generic name alsX with an extra "name"/"desc" file.
> 
> > After that I'm guessing ping Andrew Morton to see if he is willing to handle the push
> > to Linus? Or does Zhang want to try doing one directly?
> > 
> I'll refresh the patch and send to Andrew.
>

Rui,

Is there any progress on this? I haven't seen a patch refresh on LKML. 

I can help if you need any.

Regards,
Amit


-- 
-------------------------------------------------------------------------
Amit Kucheria,				 Kernel Developer, Verdurent
-------------------------------------------------------------------------
