Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbYJQXs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbYJQXs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 19:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbYJQXsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 19:48:21 -0400
Received: from kroah.org ([198.145.64.141]:37869 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752859AbYJQXsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 19:48:20 -0400
Date: Fri, 17 Oct 2008 16:43:07 -0700
From: Greg KH <greg@kroah.com>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] Linux 2.6.25.17
Message-ID: <20081017234307.GA5270@kroah.com>
References: <20080908143516.GA7311@suse.de> <200810142319.33603.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200810142319.33603.caglar@pardus.org.tr>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 11:19:25PM +0300, S.Çağlar Onur wrote:
> Hi;
> 
> 08 Eyl 2008 Pts tarihinde, Greg KH şunları yazmıştı: 
> > We (the -stable team) are announcing the release of the 2.6.25.17
> > kernel.
> > 
> > It contains lots of bugfixes, all over the map.  Any users of the 2.6.25
> > kernel series should upgrade to this version.  For details on the fixes,
> > see the changelog entries and the diffstat below.
> [...]
> 
> > Yinghai Lu (1):
> >       x86: work around MTRR mask setting
> 
> That particular patch causes _lots_ of WARN_ON messages on one of our servers and following commit in Linus's tree solved that problem. If -stable team will release another .25 update maybe following patch can be considered to solve that sitation introduced with 2.6.2.5.17
> 
> commit 9754a5b840a209bc1f192d59f63e81b698a55ac8

Now queued up, thanks for letting us know.

greg k-h
