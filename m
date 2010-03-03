Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab0CCVCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 16:02:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44363 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841Ab0CCVCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 16:02:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michal Hocko <mstsxfx@gmail.com>
Subject: Re: unable to handle kernel paging request on resume with 2.6.33-00001-gbaac35c
Date: Wed, 3 Mar 2010 22:04:51 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-git-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>, linux-mm@kvack.org
References: <20100301175256.GA4034@tiehlicka.suse.cz> <201003022101.21521.rjw@sisk.pl> <20100303102621.GC4241@tiehlicka.suse.cz>
In-Reply-To: <20100303102621.GC4241@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003032204.51167.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 March 2010, Michal Hocko wrote:
> On Tue, Mar 02, 2010 at 09:01:21PM +0100, Rafael J. Wysocki wrote:
> > On Tuesday 02 March 2010, Michal Hocko wrote:
...
> > So this is just plain 2.6.33 plus one commit.
> > 
> > Hmm.  There are only a few changes directly related to hibernation in that
> > kernel and none of them can possibly introduce a problem like that.
> 
> My previous kernel was vmlinux-2.6.33-rc8-00164-gaea187c and it didn't
> show the problem.

Well, I have no idea which of the commits between -rc8 and .33 final might
introduce such a problem.

What graphics is there in the affected box?

Rafael
