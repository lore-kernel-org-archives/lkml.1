Return-Path: <linux-kernel-owner+w=401wt.eu-S1761457AbYCUADc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761457AbYCUADc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 20:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760723AbYCUAAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 20:00:54 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:33884 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760715AbYCUAAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 20:00:53 -0400
Date: Fri, 21 Mar 2008 01:00:52 +0100 (CET)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-kernel@vger.kernel.org
Subject: Re: APM lockups since 2.6.25
In-Reply-To: <200803201131.25828.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.0803210059440.2540@artax.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0803191608500.25941@artax.karlin.mff.cuni.cz>
 <200803201131.25828.rjw@sisk.pl>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > Hi
> 
> Hi,
>  
> > I have an old notebook with APM and I am experiencing occasional APMD 
> > lockups after resume, with kernels 2.6.25rc1 snd 2.6.25rc3. They didn't 
> > happen with 2.6.24 or before.
> > 
> > The bug happens about once a week or so.
> > 
> > If you have any idea how to debug it, you can send me a test code.
> 
> It is possible that the bug was fixed in -rc4.  Can you please test -rc6 and
> see if it's still present?
> 
> Thanks,
> Rafael

I'm now running on -rc6, so I'll see (it takes some days for the bug to 
appear). Where is that patch that went to -rc4 and that may fix it?

Mikulas
