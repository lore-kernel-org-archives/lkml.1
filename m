Return-Path: <linux-kernel-owner+w=401wt.eu-S1752430AbZHSRjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbZHSRjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 13:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbZHSRjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 13:39:13 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:27162 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751202AbZHSRjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 13:39:12 -0400
Subject: Re: [PATCH] staging/wlan-ng: Convert firmware loading to load
 binary ihex format
From: Karl Relton <karllinuxtest.relton@ntlworld.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090819163439.GA3094@kroah.com>
References: <1250665599.4545.3.camel@localhost>
	 <20090819154437.GA729@kroah.com> <1250698851.4323.9.camel@localhost>
	 <20090819163439.GA3094@kroah.com>
Content-Type: text/plain
Date: Wed, 19 Aug 2009 18:39:09 +0100
Message-Id: <1250703549.4323.16.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.0 c=1 a=77gSv6d_8poA:10 a=TfPwwAdzkwpWz82hI0AA:9 a=Ah3Eu6E3pTg4yGMc9o8A:7 a=RSHe6NtUqmBHww33yxd6-MOfglYA:4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-19 at 09:34 -0700, Greg KH wrote:
> On Wed, Aug 19, 2009 at 05:20:51PM +0100, Karl Relton wrote:
> > I plan to give the various distributions a utility to pre-compile the
> > firmware. It is based on ihex2fw.c.
> > 
> > I don't think the firmware will ever be accepted into linux-firmware
> > because the original licensing cannot be established.
> 
> Have you asked the company?
> Where is the firmware at today?
> 

At some point in the past the owner was Conexant, but we are not sure
they still own in. Some efforts to track down which company now owns
this firmware, and who the contact within that company would be, have
been made but have not been successful.

The firmware is downloadable from the linux-wlan-ng project. I have been
liasing with the maintainer in that project, who has tried to help as
far as he could.

Karl

