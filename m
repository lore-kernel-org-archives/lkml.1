Return-Path: <linux-kernel-owner+w=401wt.eu-S934714AbYBHUBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934714AbYBHUBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:01:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758273AbYBHUBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:01:39 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:43815 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758173AbYBHUBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:01:38 -0500
Date: Fri, 8 Feb 2008 21:01:44 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       isdn4linux@listserv.isdn4linux.de, kkeil@suse.de, jgarzik@pobox.com
Subject: Re: [PATCH] isdn: fix section mismatch warning in enpci_card_msg
Message-ID: <20080208200144.GA31984@uranus.ravnborg.org>
References: <1201873364-13475-3-git-send-email-sam@ravnborg.org> <20080207.182040.196977279.davem@davemloft.net> <20080208055833.GA26183@uranus.ravnborg.org> <20080207.222730.61110620.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207.222730.61110620.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 10:27:30PM -0800, David Miller wrote:
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Fri, 8 Feb 2008 06:58:33 +0100
> 
> > Hi David - did you apply only this
> > or all 5 patches?
> > I can resend if you prefer with Karsten's ack included.
> 
> Only this one, I don't have the others so feel free to send
> thos.
> 
> > PS. Do you usual take isdn patches?
> 
> Lately that has been the case.
Fine - I just sent you the other four patches I had queued.
With these isdn is now free of section mismatches.

	Sam
