Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbYLLUIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbYLLUIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 15:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbYLLUIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 15:08:05 -0500
Received: from relais.videotron.ca ([24.201.245.36]:47757 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbYLLUID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 15:08:03 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 12 Dec 2008 15:07:38 -0500 (EST)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Simplified GIT usage guide
In-reply-to: <20081212182827.28408.40963.stgit@warthog.procyon.org.uk>
Message-id: <alpine.LFD.2.00.0812121459400.30035@xanadu.home>
References: <20081212182827.28408.40963.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Another obvious correction...

On Fri, 12 Dec 2008, David Howells wrote:

> +     A commit object will typically refer to one base commit when someone has
> +     merely committed some changes on top of the current state, and two base
> +     commits when a couple of trees have been merged.

If you have two bases, then only two trees were merged together.  If you 
merged a "couple" of trees, then a "couple" of bases are registered.


Nicolas

