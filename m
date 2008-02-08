Return-Path: <linux-kernel-owner+w=401wt.eu-S1757622AbYBHVOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622AbYBHVOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbYBHVOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:14:36 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:64276 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbYBHVOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:14:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JVglXHHTwwPt3rRoNS22lFJwVzGJjXTmGUN+HAW8Q1z7gco35yvHFzxhqS7uAfu9Dq32ypoanfym2myNEexmYv9g56zmc4soKFPwaUMmQD5oQVtGy8/hImStaN3xm2lYrhuMV3wfP3ewQvt2TNmqbp9cmZrR4VUqiC3KNPZ9H+8=
Message-ID: <6101e8c40802081314q41a37a50o9d343aee569b9731@mail.gmail.com>
Date: Fri, 8 Feb 2008 22:14:30 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: Linux 2.6.24.1
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
In-Reply-To: <20080208210756.GA5429@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080208203404.GC4520@kroah.com>
	 <6101e8c40802081300o3a978d9axef5ca3040d6a5839@mail.gmail.com>
	 <20080208210756.GA5429@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ok, the git pull methon worked with the begin, but the gitweb not, ok,
than in a 30 min I checked

On 2/8/08, Greg KH <gregkh@suse.de> wrote:
> On Fri, Feb 08, 2008 at 10:00:56PM +0100, Oliver Pinter wrote:
> > Hi!
> >
> > the v2.6.24.y tree is not published or not visible with git-web on
> >
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.24.y.git;a=summary
> > address
>
> Hm, that was odd, Chris created that tree in a different way than
> normal, which worked to push and pull from directly through ssh, but
> didn't work through the gitweb interface.
>
> It should be fixed now, but might take 30 minutes or so to propagate.
>
> If within an hour, it's still not working, please let me know.
>
> thanks,
>
> greg k-h
>


-- 
Thanks,
Oliver
