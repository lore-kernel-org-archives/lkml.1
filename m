Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbZCULVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbZCULVz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 07:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbZCULVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 07:21:42 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46247 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbZCULVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 07:21:41 -0400
Date: Sat, 21 Mar 2009 12:24:24 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jochen =?iso-8859-1?B?Vm/f?= <jochen.voss@googlemail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       mtk.manpages@gmail.com, tytso@mit.edu, rdunlap@xenotime.net,
       linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: ext2/3: document conditions when reliable operation is possible
Message-ID: <20090321112424.GA6253@elf.ucw.cz>
References: <20090312092114.GC6949@elf.ucw.cz> <ef1cd66f0903120440q6e49b90dye92abfaa455055b0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ef1cd66f0903120440q6e49b90dye92abfaa455055b0@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-03-12 11:40:52, Jochen Voß wrote:
> Hi,
> 
> 2009/3/12 Pavel Machek <pavel@ucw.cz>:
> > diff --git a/Documentation/filesystems/ext2.txt b/Documentation/filesystems/ext2.txt
> > index 4333e83..b09aa4c 100644
> > --- a/Documentation/filesystems/ext2.txt
> > +++ b/Documentation/filesystems/ext2.txt
> > @@ -338,27 +339,25 @@ enough 4-character names to make up unique directory entries, so they
> >  have to be 8 character filenames, even then we are fairly close to
> >  running out of unique filenames.
> >
> > +Requirements
> > +============
> > +
> > +Ext3 expects disk/storage subsystem to behave sanely. On sanely
>    ^^^^
> Shouldn't this be "Ext2"?

Thanks, fixed.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
