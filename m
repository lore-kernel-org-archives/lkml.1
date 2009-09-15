Return-Path: <linux-kernel-owner+w=401wt.eu-S1758738AbZIOXK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbZIOXK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 19:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbZIOXKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 19:10:55 -0400
Received: from kroah.org ([198.145.64.141]:43471 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbZIOXKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 19:10:54 -0400
Date: Tue, 15 Sep 2009 16:01:40 -0700
From: Greg KH <greg@kroah.com>
To: Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       stable-review@kernel.org
Subject: Re: [patch 00/74] 2.6.30.5-stable review
Message-ID: <20090915230140.GA24848@kroah.com>
References: <20090813195705.GA22393@kroah.com>
 <4A850395.4050204@pardus.org.tr>
 <20090814161523.GA11228@suse.de>
 <4A85984A.3050808@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A85984A.3050808@pardus.org.tr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 08:00:58PM +0300, Ozan Çağlayan wrote:
> Greg KH wrote:
> >> I wonder if it's possible to cherry-pick new device additions to
> >> usb-serial modem drivers (HSDPA stuff) for further releases?
> >>     
> >
> > Sure, send me the git commit ids that you want added please.
> >   
> 
> Sure, here they are:

Ugh, with .31 out, all of these are just not worth adding to the tree
anymore, I'd like to only make one more .30 release, so if we can not
include these, it makes my life a lot easier.

thanks,

greg k-h
