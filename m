Return-Path: <linux-kernel-owner+w=401wt.eu-S1757666AbYAHNSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757666AbYAHNSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 08:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757481AbYAHNSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 08:18:24 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:47839 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757476AbYAHNSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 08:18:23 -0500
Date: Tue, 8 Jan 2008 14:18:23 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Li Yang <leoli@freescale.com>
Cc: torvalds@linux-foundation.org, gregkh@suse.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-kernel@zh-kernel.org
Subject: Re: [GIT PATCH] Update to Chinese documents
Message-ID: <20080108131823.GB23947@uranus.ravnborg.org>
References: <1199796637.6835.7.camel@Gundam>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199796637.6835.7.camel@Gundam>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 08:50:37PM +0800, Li Yang wrote:
> Please pull from the doc branch at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/leo/chinese.git doc
> 
> to receive the following updates to in-tree Chinese documents
> and to add newly translated guideline documents.

Hi Li Yang.

In another thread we have discussed localized versions of Kconfig
files facilitating po files.
Will the community you represent here see any advantage in that and
would be interested to contribute?

What is generally seen as a showstopper is the amount of work needed
to do the translation - and keeping it up-to-date.

If lkml actually accept .po files in the kernel is not yet setteled
but no matter I would like kconfig to be extended to support it.
For this work help is needed too.
It is a pick-up of the Linux Kernel Translation project
(http://tlktp.sourceforge.net/) where several kconfig patches exists.

	Sam
