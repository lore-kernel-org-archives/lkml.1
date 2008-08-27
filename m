Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbYH0Q7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbYH0Q7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 12:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759281AbYH0Q6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 12:58:44 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:55091 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759269AbYH0Q6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 12:58:42 -0400
Date: Wed, 27 Aug 2008 12:58:42 -0400
To: Jesper Krogh <jesper@krogh.cc>
Cc: linux-kernel@vger.kernel.org
Subject: Re: task blocked for more than 120 seconds - 2.6.26.1
Message-ID: <20080827165842.GE12476@csclub.uwaterloo.ca>
References: <15219.195.41.66.226.1219844762.squirrel@mail.jabbernet.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15219.195.41.66.226.1219844762.squirrel@mail.jabbernet.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 03:46:02PM +0200, Jesper Krogh wrote:
> I seem to be getting these more frequently on 2.6.26.1
> 
> 16 core Sun X4600 amd64 with 60GB memory.

My Q6600 amd64 mythtv box has been hanging for minutes at a time before
simply returning to normal quite a few times under 2.6.26, while 2.6.25
shows no issues at all.  I have seen the same message as you about a
task being blocked or stuck as well when this happens.

I didn't want to complain about it since I run tainted with the nvidia
driver and without the nvidia driver I wouldn't be able to use it and
reproduce the problem, so I figured there was no point.

-- 
Len Sorensen
