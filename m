Return-Path: <linux-kernel-owner+w=401wt.eu-S1030580AbXDWDrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030580AbXDWDrD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 23:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030622AbXDWDrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 23:47:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030580AbXDWDrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 23:47:01 -0400
Message-ID: <462C2E5B.1080008@redhat.com>
Date: Sun, 22 Apr 2007 23:56:11 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Eric Hopper <hopper@omnifarious.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Question about Reiser4
References: <20070423020046.GA28477@omnifarious.org>
In-Reply-To: <20070423020046.GA28477@omnifarious.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Hopper wrote:
> I know that this whole effort has been put in disarray by the
> prosecution of Hans Reiser, but I'm curious as to its status. 

It was in disarray well before.  Many of the reiser4 features,
like filesystem plugins, make more technical sense in the Linux
VFS, but made more business sense for Namesys as a reiserfs 4
thing.  That lead to a stalemate.

 > Is Reiser4 going to be going into the Linus kernel anytime soon?

I wouldn't count on it.
