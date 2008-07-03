Return-Path: <linux-kernel-owner+w=401wt.eu-S1755598AbYGCS7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbYGCS7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 14:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbYGCS7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 14:59:03 -0400
Received: from ns1.suse.de ([195.135.220.2]:58042 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910AbYGCS7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 14:59:02 -0400
Date: Thu, 3 Jul 2008 11:57:27 -0700
From: Greg KH <greg@kroah.com>
To: spender-@grsecurity.net, pageexec@freemail.hu
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.25.10
Message-ID: <20080703185727.GA12617@suse.de>
References: <20080703035807.GA8190@kroah.com> <e2e108260807031008r3de9aad7v8222d41fd750b9da@mail.gmail.com> <20080703172914.GA11123@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080703172914.GA11123@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 10:29:14AM -0700, Greg KH wrote:
> On Thu, Jul 03, 2008 at 07:08:48PM +0200, Bart Van Assche wrote:
> > On Thu, Jul 3, 2008 at 5:58 AM, Greg KH <gregkh@suse.de> wrote:
> > > We (the -stable team) are announcing the release of the 2.6.25.10
> > > kernel.
> > >
> > > It contains a number of assorted bugfixes all over the tree.  And once
> > > again, any users of the 2.6.25 kernel series are STRONGLY encouraged to
> > > upgrade to this release.
> > 
> > Hello Greg,
> > 
> > Thanks for all the work you and the stable team are doing on the
> > stable series. To me the above message is a little bit cryptic however
> > -- which bugs have been fixed, and what was their impact ? I know it
> > takes time to write down such information, sometimes called release
> > notes. But I think including this information with the announcements
> > of the stable releases would be a great service to the people reading
> > these announcements.
> 
> The release notes are there in the shortlog in the email announcement
> and full Changelog on the kernel.org site for exactly what specifically
> was fixed:
> 	http://www.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.25.10
> 
> If you have any specific questions about any of the individual changes,
> please let us, and the developers who made those fixes know.

Adding 2 more addresses to this thread, as they were said to have
questions about this kernel release.

Again, if the above information is somehow insufficient as to what
exactly is fixed in the -stable releases, and anyone has questions about
how these release announcements are created, please let me know.

thanks,

greg k-h
