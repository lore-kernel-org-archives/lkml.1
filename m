Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab0CDJCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 04:02:16 -0500
Received: from nat.scz.novell.com ([213.151.88.252]:59135 "EHLO dhcp35"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754780Ab0CDJCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 04:02:09 -0500
Date: Thu, 4 Mar 2010 10:02:07 +0100
From: Michal Hocko <mstsxfx@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>, linux-mm@kvack.org
Subject: Re: unable to handle kernel paging request on resume with
 2.6.33-00001-gbaac35c
Message-ID: <20100304090207.GA4640@tiehlicka.suse.cz>
References: <20100301175256.GA4034@tiehlicka.suse.cz>
 <201003022101.21521.rjw@sisk.pl>
 <20100303102621.GC4241@tiehlicka.suse.cz>
 <201003032204.51167.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003032204.51167.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 10:04:51PM +0100, Rafael J. Wysocki wrote:
> On Wednesday 03 March 2010, Michal Hocko wrote:
> > On Tue, Mar 02, 2010 at 09:01:21PM +0100, Rafael J. Wysocki wrote:
> > > On Tuesday 02 March 2010, Michal Hocko wrote:
> ...
> > > So this is just plain 2.6.33 plus one commit.
> > > 
> > > Hmm.  There are only a few changes directly related to hibernation in that
> > > kernel and none of them can possibly introduce a problem like that.
> > 
> > My previous kernel was vmlinux-2.6.33-rc8-00164-gaea187c and it didn't
> > show the problem.
> 
> Well, I have no idea which of the commits between -rc8 and .33 final might
> introduce such a problem.
> 
> What graphics is there in the affected box?

00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME,
943/940GML Express Integrated Graphics Controller (rev 03))

> 
> Rafael

-- 
Michal Hocko
