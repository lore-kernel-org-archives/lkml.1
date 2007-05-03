Return-Path: <linux-kernel-owner+w=401wt.eu-S1030190AbXECKMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030190AbXECKMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 06:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbXECKMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 06:12:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48968 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbXECKMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 06:12:31 -0400
Date: Thu, 3 May 2007 12:12:28 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, wfg@ustc.edu
Subject: Re: 2.6.22 -mm merge plans
Message-ID: <20070503101228.GA18481@one.firstfloor.org>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <p733b2gzqkg.fsf@bingen.suse.de> <20070501220803.GA27698@Krystal> <20070502104413.GC4392@one.firstfloor.org> <20070502094707.4197ab7a.akpm@linux-foundation.org> <20070502174940.GA9089@one.firstfloor.org> <463906C0.1080208@imap.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463906C0.1080208@imap.cc>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 11:46:40PM +0200, Tilman Schmidt wrote:
> Am 02.05.2007 19:49 schrieb Andi Kleen:
> > And also I think when something is merged it should have some users in tree.
> 
> Isn't that a circular dependency?

The normal mode of operation is to merge the initial users and the 
subsystem at the same time.

-Andi
