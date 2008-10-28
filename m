Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbYJ1GnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbYJ1GnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 02:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbYJ1GnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 02:43:17 -0400
Received: from lutt.itea.ntnu.no ([129.241.18.234]:57766 "EHLO
	lutt.itea.ntnu.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbYJ1GnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 02:43:16 -0400
From: Henrik Austad <henrik@austad.us>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] cgroup: remove unused variable
Date: Tue, 28 Oct 2008 07:42:23 +0100
User-Agent: KMail/1.9.10
Cc: "Luck, Tony" <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>
References: <200810272303.m9RN3Dw8032499@agluck-lia64.sc.intel.com> <alpine.LFD.2.00.0810271607220.3386@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810271607220.3386@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810280742.23976.henrik@austad.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2008 00:08:24 Linus Torvalds wrote:
> 
> On Mon, 27 Oct 2008, Luck, Tony wrote:
> > 
> > Linus,  I guess you don't build with CONFIG_CGROUPS=y or you'd
> > have fixed this, or taken one of the patches that fix it. I'm
> > tired of seeing the warning in my build log :-)
> 
> Hmm.. Committed on Sunday. Should hav been in -rc2 already, no?

yes, commit 207777664

-- 
henrik
