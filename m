Return-Path: <linux-kernel-owner+w=401wt.eu-S1761332AbYBSJya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761332AbYBSJya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 04:54:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbYBSJyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 04:54:23 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:36991 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbYBSJyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 04:54:23 -0500
Date: Tue, 19 Feb 2008 10:54:23 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Gregory Nietsky <gregory@networksentry.co.za>
Cc: Andi Kleen <andi@firstfloor.org>, Greg KH <greg@kroah.com>, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: Plans for mISDN? Was: [PATCH 00/14] [ISDN] ...
Message-ID: <20080219095423.GB4164@uranus.ravnborg.org>
References: <098123kjff90231nv098233rnvd908u234@garzik.org> <20080217195235.GN14588@uranus.ravnborg.org> <20080218045209.GA15141@kroah.com> <p73zltyxy9q.fsf@bingen.suse.de> <20080219085033.GA1775@uranus.ravnborg.org> <47BAA072.9050601@networksentry.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BAA072.9050601@networksentry.co.za>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 11:25:06AM +0200, Gregory Nietsky wrote:
> ive been hackin away at mISDN for a while and use it with recent kernels 
>  2.6.2X and have a patch for 2.6.24 (move from semaphore to complition) 
> the distro we built is heavily reliant on mISDN (voip) i dont use the 
> isdn kernel drivers at all any longer.
> 
> im all for mISDN been mainlined into the kernel and the old stuff been 
> removed there could be users still it is marked as depricated and the 
> plan was with 2.6 to use mISDN from the start.

Great!

First step would be to send a properly splitted up patchset for review
if is is ready.
Release early - relase often is the best way.

I will do my best to review the bits I can help with.

	Sam
