Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbYKXLHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbYKXLHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 06:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbYKXLGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 06:06:34 -0500
Received: from cantor.suse.de ([195.135.220.2]:53260 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbYKXLGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 06:06:30 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jeff Arnold <jbarnold@mit.edu>
Subject: Re: [RFC] kreplace: Rebootless kernel updates
Date: Mon, 24 Nov 2008 16:37:38 +0530
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com, davem@davemloft.net,
       mhiramat@redhat.com, contact@ksplice.com, jbarnold@ksplice.com,
       tabbott@ksplice.com, wdaher@ksplice.com, andersk@ksplice.com
References: <200811211720.26394.knikanth@suse.de> <alpine.DEB.2.00.0811211303460.24014@vinegar-pot.mit.edu>
In-Reply-To: <alpine.DEB.2.00.0811211303460.24014@vinegar-pot.mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200811241637.39277.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 November 2008 09:16:59 Jeff Arnold wrote:
> Hello,
>
> > [kreplace] is currently a x86_64 only _hack_
>
> The point of Ksplice is to be a hot update system that isn't a hack.
> Ksplice is quite far along at this point; it implements many safety and
> automation features that kreplace doesn't address. 

I agree.

> Is there something in particular that discouraged you from using Ksplice?
>

It is not mainline yet. And just the curiosity of doing it some other way with 
minimal code.

Thanks
Nikanth Karthikesan


