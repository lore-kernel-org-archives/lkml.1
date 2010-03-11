Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab0CKDoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 22:44:09 -0500
Received: from cantor.suse.de ([195.135.220.2]:45716 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755321Ab0CKDoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 22:44:07 -0500
Date: Wed, 10 Mar 2010 19:32:48 -0800
From: Greg KH <gregkh@suse.de>
To: Joe Perches <joe@perches.com>
Cc: Andr? Silva <andre.beat@gmail.com>, linville@tuxdriver.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: arlan: fixed coding style issues in
	arlan-proc.c This is a patch to the arlan-proc.c file that fixes up
	multiple coding style errors and warnings found by the
	checkpatch.pl tool Signed-off-by: Andre Silva <andre.beat@gmail.com>
Message-ID: <20100311033248.GA3832@suse.de>
References: <1268276306-14324-1-git-send-email-andre.beat@gmail.com> <1268278090.1674.37.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268278090.1674.37.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 07:28:10PM -0800, Joe Perches wrote:
> On Thu, 2010-03-11 at 02:58 +0000, Andr?? Silva wrote:
> > From: Andre Silva <andre.beat@gmail.com>
> 
> Hi Andre.
> 
> When you send a patch, please use a shorter subject
> and add some commentary in the body of the email
> that describes the changes before the patch itself.

He did, it's a "issue" with git-send-email that if you don't have empty
lines, it puts it all on the Subject: line.

I'm used to fixing it up, so no big deal,

greg k-h
