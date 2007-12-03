Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbXLCM5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbXLCM5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 07:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbXLCM5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 07:57:23 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58210 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbXLCM5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 07:57:23 -0500
Date: Mon, 3 Dec 2007 04:57:39 -0800
From: Greg KH <greg@kroah.com>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [stable] [kvm-devel] [PATCH 00/10]: KVM updates for 2.6.23.9
	(-stable)
Message-ID: <20071203125739.GA12233@kroah.com>
References: <1196594327338-git-send-email-avi@qumranet.com> <20071202190829.GA22385@kroah.com> <4753CB07.7080807@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4753CB07.7080807@qumranet.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2007 at 11:23:19AM +0200, Avi Kivity wrote:
> Greg KH wrote:
> > On Sun, Dec 02, 2007 at 01:18:37PM +0200, Avi Kivity wrote:
> >   
> >> The following patchset fixes some bugs in KVM for the next 2.6.23.y stable
> >> release.  Please apply.
> >>     
> >
> > I'm guessing that all of these are already upstream in Linus's tree?
> >
> >   
> 
> Yes, except one, which has been changed in a different way for 2.6.24.
> 
> > If so, can you give me the git commit ids for them all if you happen to
> > know them, so that I don't have to guess at them?  :)
> >
> >   
> 
> 1 a012e65aee48379a7a87eadafa74f878b61522b9
> 2 4e62417bf317504c0b85e0d7abd236f334f54eaf
> 3 651a3e29b3d19418d7a8a9787906061f9be7cc5f
> 4 cf5a94d1331b411b84414c13e43f578260942d6b
> 5 00b2ef475d4728ca53a2bc788c7978042907e354
> 6 N/A
> 7 404fb881b82cf0cf6981832f8d31a7484e4dee81
> 8 0967b7bf1c22b55777aba46ff616547feed0b141
> 9 78f7826868da8e27d097802139a3fec39f47f3b8
> 10 8668a3c468ed55d19514117a5a959d91d3d03823

Thanks, I appreciate it.

greg k-h
