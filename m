Return-Path: <linux-kernel-owner+w=401wt.eu-S1757793AbZBXBkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793AbZBXBkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 20:40:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbZBXBki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 20:40:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43146 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbZBXBkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 20:40:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: Re: [stable] 2.6.29-rc6: Reported regressions 2.6.27 -> 2.6.28
Date: Tue, 24 Feb 2009 02:40:31 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-usb@vger.kernel.org Natalie Protasevich" <protasnb@gmail.com>,
       Stable Kernel Team <stable@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, kpalberg@gmail.com
References: <HFSEX4uppGO.A.JSG.2yzoJB@chimera> <20090224012959.GA25443@kroah.com>
In-Reply-To: <20090224012959.GA25443@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902240240.32584.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 February 2009, Greg KH wrote:
> On Mon, Feb 23, 2009 at 11:00:52PM +0100, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12559
> > Subject		: Huawei E169 doesn't work as mass storage anymore
> > Submitter	: kpalberg <kpalberg@gmail.com>
> > Date		: 2009-01-28 02:34 (27 days old)
> 
> I'm pretty sure this has been tracked down to a buggy firmware in the
> device itself, and the company (Huawei) is working on updating it to
> solve the issue.
> 
> This is backed up by the fact that Huawei submitted the patch that is
> said to have broken this device :)

OK, the bug is now closed as invalid.

Thanks,
Rafael
