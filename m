Return-Path: <linux-kernel-owner+w=401wt.eu-S1422976AbXCORFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422976AbXCORFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 13:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422977AbXCORFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 13:05:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422976AbXCORFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 13:05:47 -0400
Date: Thu, 15 Mar 2007 13:00:09 -0400
From: Dave Jones <davej@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.21rc suspend to ram regression on Lenovo X60
Message-ID: <20070315170009.GB17658@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
References: <20070313040828.GA17893@redhat.com> <200703131022.54322.rjw@sisk.pl> <20070313132218.GA25910@redhat.com> <m1d53apjvu.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1d53apjvu.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 10:11:01AM -0600, Eric W. Biederman wrote:

 > I haven't heard anything more on this thread.

Sorry, I've been stuck in meetings the last two days..

 > I just wanted to double check.  The tree that failed did it include
 > commits: 
 > 392ee1e6dd901db6c4504617476f6442ed91f72d and
 > 9f35575dfc172f0a93fb464761883c8f49599b7a
 > 
 > Mostly I was wondering if any of my later work to sort out msi 
 > suspend/resume actually solved anything.

I'll kick off some compiles and find out.

	Dave

-- 
http://www.codemonkey.org.uk
