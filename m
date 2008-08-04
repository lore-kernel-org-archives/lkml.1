Return-Path: <linux-kernel-owner+w=401wt.eu-S1762101AbYHDWqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762101AbYHDWqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbYHDWpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:45:17 -0400
Received: from vena.lwn.net ([206.168.112.25]:50117 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbYHDWpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:45:16 -0400
Date: Mon, 4 Aug 2008 16:45:13 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: "Chris Friesen" <cfriesen@nortel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Amanda McPherson <amanda@amcpherson.com>, Jiri Kosina <jkosina@suse.cz>,
       Roland Dreier <rdreier@cisco.com>, Alex Chiang <achiang@hp.com>,
       Jochen =?ISO-8859-1?B?Vm/f?= <jochen.voss@googlemail.com>,
       rob@landley.net
Subject: Re: [PATCH] A development process document, V2
Message-ID: <20080804164513.0fcb21dd@bike.lwn.net>
In-Reply-To: <48921FA5.6060507@nortel.com>
References: <20080731111443.2179bf4c@bike.lwn.net>
	<48921FA5.6060507@nortel.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.5; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008 14:25:09 -0600
"Chris Friesen" <cfriesen@nortel.com> wrote:

> In the documentation section, you might add a link to 
> "http://kernel.org/doc/" since it isn't linked from the main
> kernel.org page.

I had thought about that.  But the revision log for that page
(http://landley.net/hg/kdocs) suggests that the last substantive
changes were made in 2007; it appears to be unmaintained at this
point.  So I hesitate to add a link to it.  Rob, do you have any plans
for this page?

Thanks,

jon
