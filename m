Return-Path: <linux-kernel-owner+w=401wt.eu-S1757800AbXEaIJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800AbXEaIJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 04:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbXEaIJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 04:09:05 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:46232 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbXEaIJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 04:09:01 -0400
Date: Thu, 31 May 2007 13:38:17 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Extending boot protocol & bzImage for paravirt_ops
Message-ID: <20070531080817.GB8685@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <4656FB8F.4090604@goop.org> <m14pm0c0m2.fsf@ebiederm.dsl.xmission.com> <465E05E7.20409@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465E05E7.20409@goop.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 04:16:55PM -0700, Jeremy Fitzhardinge wrote:
> Eric W. Biederman wrote:
> > I think we should start there and be prepared to munge the ELF
> > magic number if there are problems.  Placing ELF notes is going
> > to require a little work but mostly it should be a matter of
> > copying the from vmlinux.
> >   
> 
> Do you have a semi-current ELF bzImage patch on hand I can start playing
> with?
>

Following is the link to the patch which was posted last time and made
into -mm. But andrew had some old Fedora machine (I think FC2) and some
lilo version on that machine which failed to boot, hence this patch was
dropped.

http://marc.info/?l=linux-kernel&m=115989722229057&w=2

Thanks
Vivek
