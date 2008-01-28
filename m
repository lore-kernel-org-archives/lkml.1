Return-Path: <linux-kernel-owner+w=401wt.eu-S1760362AbYA1TdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760362AbYA1TdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:33:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbYA1Tc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:32:58 -0500
Received: from relay2.sgi.com ([192.48.171.30]:48168 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753033AbYA1Tc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:32:57 -0500
Date: Mon, 28 Jan 2008 13:32:54 -0600
From: Paul Jackson <pj@sgi.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: michael-lists@free-electrons.com, rob@landley.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Documentation: mention email-clients.txt in
 SubmittingPatches
Message-Id: <20080128133254.f70d50c2.pj@sgi.com>
In-Reply-To: <20080128081759.4efa8544.randy.dunlap@oracle.com>
References: <200801181120.03168.michael-lists@free-electrons.com>
	<20080118083415.07c37f2a.randy.dunlap@oracle.com>
	<20080128095245.f8306466.pj@sgi.com>
	<20080128081759.4efa8544.randy.dunlap@oracle.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy wrote:
> Does Sylpheed IMAP do filtering for you?
> 
> It does not according to the Sylpheed FAQ, but the FAQ is
> extremely out of date.

You are correct that the Sylpheed FAQ, such as at:

    http://sylpheeddoc.sourceforge.net/en/faq/faq-1.html

states:

    1.8 Q08 Does Sylpheed have mail filtering?
    A. Yes. You can find it in Configuration -> filtering tab.
    Please note that filtering is not yet implemented for IMAP accounts. 

And you are correct -- that FAQ is out of date.  It seems to be
dated 2002.

To answer your question, yes filtering now works fine on IMAP folders
using Sylpheed.  I make heavy use of it.  I'm using Sylpheed version
2.2.4 at the moment.

===

Be that as it may, whether Sylpheed IMAP folder filters worked or not,
I'd suggest that the Documentation/email-clients.txt file not engage
in evaluation of the general purpose feature sets of various email
clients, but rather confine itself to what matters to the kernel
mailing list, such as how to get patches formatted correctly.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
