Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbYAWOMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbYAWOMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 09:12:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYAWOMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 09:12:45 -0500
Received: from ext-ch1gw-7.online-age.net ([64.37.194.15]:34992 "EHLO
	ext-ch1gw-7.online-age.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751942AbYAWOMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 09:12:44 -0500
Date: Wed, 23 Jan 2008 15:12:22 +0100
From: Karl Kiniger <karl.kiniger@med.ge.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: David Newall <davidn@davidnewall.com>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
Message-ID: <20080123141222.GA29243@wszip-kinigka.euro.med.ge.com>
References: <20080120031153.GB6275@one.firstfloor.org> <4792D221.1010704@davidnewall.com> <20080120051822.GB19784@one.firstfloor.org> <4792DD22.4070902@davidnewall.com> <20080120055544.GB19861@one.firstfloor.org> <4792E8E2.1090307@davidnewall.com> <20080120072922.GA21047@one.firstfloor.org> <4793F775.6090403@davidnewall.com> <20080122102436.GA15563@wszip-kinigka.euro.med.ge.com> <p73k5m1lygb.fsf@crumb.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73k5m1lygb.fsf@crumb.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-GEHealthcare-MailScanner: Found to be clean
X-GEHealthcare-MailScanner-From: karl.kiniger@med.ge.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 080123, Andi Kleen wrote:
> Karl Kiniger <karl.kiniger@med.ge.com> writes:
> 
> > FYI, 
> > 
> > on http://www.feise.com/~jfeise/Downloads/linux-abi/
> > 
> > a patch named  linux-abi-2.6.22.3_3.diff.bz2 can be found.
> 
> So just add a reversed version of my binfmt_elf patch to that.
> If people need to apply a patch anyways it doesn't make much
> difference if it has a few more hunks.

it will force to recompile. The latest version of linux-abi  on 
SourceForge is named ibcs-3_4.tgz and IIRC it can be built
as an external module w/o kernel recompile.

Karl

> 
> -Andi

-- 
Karl Kiniger            mailto:karl.kiniger@med.ge.com
GE Medical Systems Kretztechnik GmbH & Co OHG
Tiefenbach 15           Tel: (++43) 7682-3800-710  Voip(GE): 1662 710
A-4871 Zipf Austria     Fax: (++43) 7682-3800-47 C: +43 6991 3800 710
