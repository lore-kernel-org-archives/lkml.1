Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbYEHRmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbYEHRmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 13:42:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYEHRly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 13:41:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47917 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbYEHRlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 13:41:53 -0400
Date: Thu, 8 May 2008 10:27:28 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Subject: Re: [stable] [00/12] 2.6.24-stable review
Message-ID: <20080508172728.GA29379@kroah.com>
References: <481792A6.406@web.de> <4F9D5D6690%linux@youmustbejoking.demon.co.uk> <20080501033932.GC6339@kroah.com> <4F9EA73ECC%linux@youmustbejoking.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9EA73ECC%linux@youmustbejoking.demon.co.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 04:24:31PM +0100, Darren Salt wrote:
> I demand that Greg KH may or may not have written...
> 
> > On Wed, Apr 30, 2008 at 04:21:44AM +0100, Darren Salt wrote:
> >> I demand that J??rg-Volker Peetz may or may not have written...
> >>> How about this one?
> >>> http://lkml.org/lkml/2008/4/7/55
> >> And this one? http://lkml.org/lkml/2008/3/13/232
> >> (commit 03c086a747d0b242878eb881971ec61c1555869d)
> 
> > Did anyone send it to stable@kernel.org and ask for it to be included?
> 
> I sent it to stable@ when I originally submitted the patch. The message ID is
> <4F84E87BA4%linux@youmustbejoking.demon.co.uk>.

Ok, I see it now.

In it you did not mention if this change was already in Linus's tree,
and if so, what git id it was.  As you sent it primarily to lkml, I
assumed that it was not upstream at this time, hence I did not apply it.

As 2.6.24 is pretty much not being maintained anymore, I don't think
this is an issue anymore :)

thanks,

greg k-h
