Return-Path: <linux-kernel-owner+w=401wt.eu-S1765181AbXGLUsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765181AbXGLUsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 16:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757843AbXGLUsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 16:48:46 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58013 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757712AbXGLUsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 16:48:46 -0400
Date: Thu, 12 Jul 2007 22:48:28 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: S3 state transition
Message-ID: <20070712204828.GA3374@elf.ucw.cz>
References: <A3258B497F1C1441AD36A2E8B45FD628486D78@scsmsx412.amr.corp.intel.com> <20070712141349.GB3881@ucw.cz> <A3258B497F1C1441AD36A2E8B45FD6284C73D2@scsmsx412.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A3258B497F1C1441AD36A2E8B45FD6284C73D2@scsmsx412.amr.corp.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2007-07-12 13:45:10, Agarwal, Lomesh wrote:
> I searched the archives but couldn't get much. Can you point me to code?

kernel/power/*

> Thanks,
> Lomesh
> 
> -----Original Message-----
> From: Pavel Machek [mailto:pavel@ucw.cz] 
> Sent: Thursday, July 12, 2007 7:14 AM
> To: Agarwal, Lomesh
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: S3 state transition
> 
> On Wed 2007-07-11 16:15:37, Agarwal, Lomesh wrote:
> > I am trying to understand how Linux handles S3 state transition.
> > Specially I want to understand what it does anything for processes
> > loaded at the time of transition. Any pointers to code/document will
> be
> > helpful.
> 
> Do you mean suspend2ram? Search archives for freezer flamewar.
> 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
