Return-Path: <linux-kernel-owner+w=401wt.eu-S1752711AbYGIQfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbYGIQfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 12:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbYGIQfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 12:35:10 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:50190 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbYGIQfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 12:35:08 -0400
Date: Wed, 9 Jul 2008 18:35:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       x86@kernel.org
Subject: Re: scripts/gcc-x86_64-has-stack-protector.sh missing ?
Message-ID: <20080709163557.GA1277@uranus.ravnborg.org>
References: <20080709155844.GB29961@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709155844.GB29961@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 11:58:44AM -0400, Dave Jones wrote:
> I just did a 'make tags' on a fresh checkout of Linus' tree, and got this..
> 
> /bin/sh: /mnt/data/src/git-trees/kernel/linux-2.6/scripts/gcc-x86_64-has-stack-protector.sh: No such file or directory
> 
> arch/x86/Makefile references this, but it seems to not be in the tree.

Added by:
4f7fd4d7a79193ceda4ce77f75e22917d33fa154

	Sam
