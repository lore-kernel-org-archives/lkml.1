Return-Path: <linux-kernel-owner+w=401wt.eu-S1756352AbYLJXyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbYLJXyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 18:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755218AbYLJXyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 18:54:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51913 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755013AbYLJXyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 18:54:39 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for December 10
Date: Thu, 11 Dec 2008 00:53:48 +0100
User-Agent: KMail/1.9.9
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
References: <20081210164659.9ebb8158.sfr@canb.auug.org.au> <20081210145226.8a174e68.akpm@linux-foundation.org>
In-Reply-To: <20081210145226.8a174e68.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812110053.49012.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 10 of December 2008, Andrew Morton wrote:
> On Wed, 10 Dec 2008 16:46:59 +1100
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > I have created today's linux-next tree at
> > git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> > (patches at
> > http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/)
> 
> This tree breaks poweroff on my x86_64 test box.  `halt -pfn' does all
> the usual things, but the machine doesn't turn off.
> 
> config: http://userweb.kernel.org/~akpm/config-akpm2.txt
> dmesg: http://userweb.kernel.org/~akpm/dmesg-akpm2.txt
> 
> Any suggestions which don't include the word "bisect" would be most welcome.

Did you suspend-resume the box before that?
