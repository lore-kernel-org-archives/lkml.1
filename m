Return-Path: <linux-kernel-owner+w=401wt.eu-S933484AbYDBUpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933484AbYDBUpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 16:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763647AbYDBUmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 16:42:37 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:34296 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759763AbYDBUmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 16:42:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=kwbHKlKeY53YjJ6p1MLu72mMqumCOMSmtJ3uR6FJ7OEiAMrWPhubNc94opexVtKmv1GPoFJxvSTLqA1lGnzwwyoDwjD5OgN64x4lDyIYrfXcIJohZx35vb/Fmq2I92nQ8pXRBGgBQgFFmy7+vNBh6PdD5PE+4GVVvRVr3hPaZ+w=  ;
X-YMail-OSG: 4cBLG54VM1lryEFxqfBSUEMvKRXE_ptNQIqpx1IWzgQM.66_8c54e.s1hgoIkZYOdUPnqYON8g--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] usb ehci_iaa_watchdog fix
Date: Wed, 2 Apr 2008 13:42:32 -0700
User-Agent: KMail/1.9.6
Cc: Mark Lord <lkml@rtr.ca>, pavel@suse.cz, oliver@neukum.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, jikos@suse.cz,
       gregkh@suse.de, akpm@linux-foundation.org
References: <Pine.LNX.4.44L0.0804021519550.11421-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0804021519550.11421-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200804021342.33102.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 April 2008, Alan Stern wrote:
> > Which one should Andrew/Linus take?
> 
> It's up to David, of course.  My preference is for the patch I 
> proposed, naturally enough.

Mine was for the one that got two "it works" confirmations.  :)


> It fixes the cause rather than the symptom.

I'm not sure I'd agree with that.

