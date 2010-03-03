Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab0CCXEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 18:04:48 -0500
Received: from smtprelay04.ispgateway.de ([80.67.31.32]:60465 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab0CCXEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 18:04:41 -0500
Date: Thu, 4 Mar 2010 00:04:38 +0100
From: M G Berberich <berberic@fmi.uni-passau.de>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.33 dies on modprobe
Message-ID: <20100303230438.GA3363@invalid>
References: <fa.S/rvLm1aQlDSqPwVJz5B+5vHjbM@ifi.uio.no>
 <fa.+Pg2gFpQSg5k/1mCpBdt8xMXeqY@ifi.uio.no>
 <fa.0/xGeZctWXDyX0DAp6opgP1HP7w@ifi.uio.no>
 <fa.kPSENj9DWu0Q8xolQMDkRvAwxQ0@ifi.uio.no>
 <fa.JUJQsT7bECqtd8JSoNY+SBdASCE@ifi.uio.no>
 <fa.Lya/54V1PJgwjc8uy1Yk4NyYUh4@ifi.uio.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fa.Lya/54V1PJgwjc8uy1Yk4NyYUh4@ifi.uio.no>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Df-Sender: 311801
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Am Mittwoch, den 03. März schrieb Américo Wang:
> On Wed, Mar 3, 2010 at 5:08 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> > On Wed, Mar 3, 2010 at 4:58 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> >> Ok, below is my patch, I am not sure it could fix the BUG for you,
> >> but it could fix the WARNING. But perhaps they are related.
> >>
> >> Please give it a try.
> >>
> >
> > Oops! Ignore the patch, it should not be correct, I will send a
> > correct version soon.
> > Sorry.
> >
> 
> Here we go:

Seems to fix the warning, but not the modprobe-Oops.

	MfG
	bmg

-- 
„Des is völlig wurscht, was heut beschlos- | M G Berberich
 sen wird: I bin sowieso dagegn!“          | berberic@fmi.uni-passau.de
(SPD-Stadtrat Kurt Schindler; Regensburg)  | www.fmi.uni-passau.de/~berberic
