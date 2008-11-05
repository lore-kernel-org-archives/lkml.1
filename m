Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbYKEFP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbYKEFP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 00:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750884AbYKEFPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 00:15:03 -0500
Received: from kroah.org ([198.145.64.141]:42013 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750743AbYKEFPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 00:15:00 -0500
Date: Tue, 4 Nov 2008 21:02:09 -0800
From: Greg KH <greg@kroah.com>
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: Jeff Garzik <jeff@garzik.org>,
       Subbu Seetharaman <subbus@serverengines.com>,
       Netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND] benet: BladeEngine 10Gb NIC driver
Message-ID: <20081105050209.GC3730@kroah.com>
References: <20081103122512.06063fc9@mailhost.serverengines.com> <20081103193641.GA12552@kroah.com> <490F5667.3080904@garzik.org> <20081103201930.GB13299@kroah.com> <Pine.LNX.4.64.0811041237400.23792@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0811041237400.23792@wrl-59.cs.helsinki.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2008 at 12:41:36PM +0200, Ilpo Järvinen wrote:
> On Mon, 3 Nov 2008, Greg KH wrote:
> 
> > Hm, call me extreemly stupid, but I don't see anything in that branch
> > for this driver.
> > 
> > Here's what I did:
> >   git fetch git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git benet master:jeff
> 
> I suppose you'd have needed instead of "benet master:jeff" just:
> 
> benet:jeff
> 
> Ie., from benet remote branch to jeff local branch (remote from the given
> repository obviously). ...Then you have that jeff branch and can checkout 
> it.

Ah, thanks, I'll try that next time.

greg k-h
