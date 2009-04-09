Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbZDIAdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbZDIAdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 20:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756070AbZDIAdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 20:33:11 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:54833 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbZDIAdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 20:33:10 -0400
Date: Thu, 9 Apr 2009 10:33:08 +1000
From: Tony Breeds <tony@bakeyournoodle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Chiang <achiang@hp.com>, Robin Holt <holt@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org
Subject: Re: cross-compilers
Message-ID: <20090409003308.GK16602@bilbo.ozlabs.org>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Alex Chiang <achiang@hp.com>, Robin Holt <holt@sgi.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ia64@vger.kernel.org
References: <20090408003921.GA5054@ldl.fc.hp.com> <20090408010331.GB10768@sgi.com> <20090408054612.GA6744@ldl.fc.hp.com> <20090407225457.86f8a458.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090407225457.86f8a458.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 10:54:57PM -0700, Andrew Morton wrote:

> We would benefit very much from having someone who actually maintains a
> suite of cross-compilers for kernel developers.

I build wont say maintain many of the cross compilers used for linux-next.  I
can place them somehere.  They're kernel only as I don't build libc.

I can build compilers for running on intel (32-bit) and powerpc (32-bit).  If
there is a need for other hosted compilers and people can give me access to an
appropriate host/VM I'll build them too.

Yours Tony
