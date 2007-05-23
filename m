Return-Path: <linux-kernel-owner+w=401wt.eu-S1758943AbXEWE5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943AbXEWE5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 00:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbXEWE5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 00:57:03 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:56634 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755861AbXEWE5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 00:57:02 -0400
Date: Wed, 23 May 2007 13:56:06 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Rob Landley <rob@landley.net>
Cc: Roland Dreier <rdreier@cisco.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Re: Cleaning up the Documentation directory.
Message-ID: <20070523045606.GA28924@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Rob Landley <rob@landley.net>, Roland Dreier <rdreier@cisco.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <200705222225.39949.rob@landley.net> <adaps4sb6x4.fsf@cisco.com> <200705230025.45007.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705230025.45007.rob@landley.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 12:25:44AM -0400, Rob Landley wrote:
>    mv arm cris blackfin parisc powerpc s390 x86_64 uml arch

You missed sh, mips, fujitsu/frv, m68k, ia64, i386, and sparc.

Is there really enough documentation for these that another directory
level is worthwhile? 00-INDEX already covers most of these things, so
it's not like there's any measurable confusion..
