Return-Path: <linux-kernel-owner+w=401wt.eu-S1759837AbYHNToT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759837AbYHNToT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 15:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbYHNToK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 15:44:10 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:51359 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753324AbYHNToJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 15:44:09 -0400
Date: Thu, 14 Aug 2008 15:44:08 -0400
To: Ryan Hope <rmh3093@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Help writing kernel module...
Message-ID: <20080814194408.GH12474@csclub.uwaterloo.ca>
References: <48f7fe350808141100h3f368a53kb371e4cefea3e70@mail.gmail.com> <20080814180207.GC12476@csclub.uwaterloo.ca> <48f7fe350808141201y24669c8foee0bea867fe612b3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48f7fe350808141201y24669c8foee0bea867fe612b3@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 03:01:56PM -0400, Ryan Hope wrote:
> what about if I want to determine if a module is loaded?

Don't know.  Of course really why would you care if a module of a
certain name is loaded.  You should only care that a module providing
the function you want is loaded.

Perhaps you need to explain what you are trying to do.

-- 
Len Sorensen
