Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbXJZEni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbXJZEni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 00:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750778AbXJZEna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 00:43:30 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:50999 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbXJZEna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 00:43:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uk2/3NBIs3vX+fWvx/vMHUt+sRQl+nPFpVJbEV464XikhuothIHEOFSMvhjBbPmzfy0OYvZqxAX6U6B3cR8CIYgxwcztD54STZwqT7VETsM68mihiDhYNBGykJePSSwztQqqiycxy+DOAzWWnxw6DdarO7dSGU1FphIHMSyTPuE=
Message-ID: <a8e1da0710252143t18278e1eg5544d900df24ddc9@mail.gmail.com>
Date: Fri, 26 Oct 2007 12:43:28 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [linux-usb-devel] usb+sysfs: duplicate filename 'bInterfaceNumber'
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
       "Matthew Dharm" <mdharm-kernel@one-eyed-alien.net>, bbpetkov@yahoo.de,
       "Kernel development list" <linux-kernel@vger.kernel.org>,
       "USB development list" <linux-usb-devel@lists.sourceforge.net>
In-Reply-To: <20071026032809.GA21901@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071025090659.GA2847@darkstar.te-china.tietoenator.com>
	 <20071025181156.GB10720@kroah.com>
	 <a8e1da0710251901r56c27efdkc7ca729c0bac003d@mail.gmail.com>
	 <20071026024201.GA21311@kroah.com>
	 <a8e1da0710252011j16ef486fvcee7816ce628b2e@mail.gmail.com>
	 <20071026032809.GA21901@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/07, Greg KH <greg@kroah.com> wrote:
> On Fri, Oct 26, 2007 at 11:11:22AM +0800, Dave Young wrote:
> > On 10/26/07, Greg KH <greg@kroah.com> wrote:
> > > > Anyway the sysfs_dirent_exist is useful for extern use, How about add
> > > > and export this function? Greg, If you agree, I would send it as
> > > > another patch.
> > >
> > > What would need that function?
> > I think the function is needed sometimes except for files related to
> > devices like usb and others that could be removed suddenly.
>
> Almost all types of devices can now be removed "suddenly" from a system.
> Hm, I almost don't know of a type that can _not_ be removed anymore...
>
> But if you have a patch that needs this function, I'd be glad to
> reconsider.
Not yet,  anyway thank you very much :)
