Return-Path: <linux-kernel-owner+w=401wt.eu-S1031011AbXDYPNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031011AbXDYPNu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 11:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031053AbXDYPNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 11:13:50 -0400
Received: from seahorse.shentel.net ([204.111.1.244]:56711 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031011AbXDYPNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 11:13:49 -0400
Date: Wed, 25 Apr 2007 11:13:45 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: Al Boldi <a1426z@gawab.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Reasons to merge suspend2.
In-Reply-To: <200704251551.38373.a1426z@gawab.com>
Message-ID: <alpine.DEB.0.98.0704251111000.18512@sigma.j-a-k-j.com>
References: <200704251551.38373.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I didn't read your whole post, it's way too long, but I would like to see 
> your patch in mainline as an option to swsusp.  What would make this 
> infeasible?

For one thing, Linus said not but yesterday that he doesn't want multiple 
competing suspend algorithms like this in the kernel at once. (If I parsed 
his message correctly, he doesn't want any in the kernel, but he's putting 
up with it because it seems somewhat needed.)
