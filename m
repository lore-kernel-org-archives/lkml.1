Return-Path: <linux-kernel-owner+w=401wt.eu-S1757169AbYDWP73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169AbYDWP73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 11:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbYDWP7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 11:59:22 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:43903 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751399AbYDWP7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 11:59:21 -0400
Date: Wed, 23 Apr 2008 11:59:20 -0400
To: Romano Giannetti <romanol@upcomillas.es>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Daniel Hazelton <dhazelton@enter.net>, david@lang.hm,
       Denys Vlasenko <vda.linux@googlemail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: x86: 4kstacks default
Message-ID: <20080423155920.GE7387@csclub.uwaterloo.ca>
References: <200804181737.m3IHbabI010051@hera.kernel.org> <200804230121.11004.dhazelton@enter.net> <alpine.DEB.1.10.0804222222490.23325@asgard> <200804230141.09523.dhazelton@enter.net> <1208936787.13905.14.camel@localhost> <480F1C60.4030305@s5r6.in-berlin.de> <1208952901.11823.13.camel@pern>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208952901.11823.13.camel@pern>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 02:15:01PM +0200, Romano Giannetti wrote:
> - vendor say "works" (and often is listed as works in the aforementioned
> sites too) independently if it works with an open source driver or not.
> As an example, all the nvidia-based graphics are marked "works".

The nv driver does work for all the nvidia cards as far as I know.  Sure
you don't get 3D acceleration, but you do get working X.

But yes it is quite annoying when companies like highpoint (and others)
claim to support linux when all they have is binary blobs as part of their
"driver".

-- 
Len Sorensen
