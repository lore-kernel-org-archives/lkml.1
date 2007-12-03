Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbXLCN20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbXLCN20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 08:28:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbXLCN2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 08:28:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46193 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbXLCN2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 08:28:18 -0500
Date: Mon, 3 Dec 2007 05:31:05 -0800
From: Greg KH <greg@kroah.com>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [stable] [kvm-devel] [PATCH 00/10]: KVM updates for 2.6.23.9
	(-stable)
Message-ID: <20071203133105.GA14450@kroah.com>
References: <1196594327338-git-send-email-avi@qumranet.com> <20071202190829.GA22385@kroah.com> <4753CB07.7080807@qumranet.com> <20071203125739.GA12233@kroah.com> <47540067.7090905@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47540067.7090905@qumranet.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2007 at 03:11:03PM +0200, Avi Kivity wrote:
> Greg KH wrote:
> 
>   
> 
> >> 1 a012e65aee48379a7a87eadafa74f878b61522b9
> >> 2 4e62417bf317504c0b85e0d7abd236f334f54eaf
> >> 3 651a3e29b3d19418d7a8a9787906061f9be7cc5f
> >> 4 cf5a94d1331b411b84414c13e43f578260942d6b
> >> 5 00b2ef475d4728ca53a2bc788c7978042907e354
> >> 6 N/A
> >> 7 404fb881b82cf0cf6981832f8d31a7484e4dee81
> >> 8 0967b7bf1c22b55777aba46ff616547feed0b141
> >> 9 78f7826868da8e27d097802139a3fec39f47f3b8
> >> 10 8668a3c468ed55d19514117a5a959d91d3d03823
> >>     
> >
> > Thanks, I appreciate it.
> >
> >   
> 
> How do you want them in the future?  Inside the individual commit logs 
> or in the introductory message?

Inside the individual commit logs is best, as that is where I have been
adding them by hand if you look at the last few releases.

thanks,

greg k-h
