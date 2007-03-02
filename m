Return-Path: <linux-kernel-owner+w=401wt.eu-S2992715AbXCBXKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992715AbXCBXKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 18:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992721AbXCBXKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 18:10:39 -0500
Received: from webmail.woosh.co.nz ([202.74.207.2]:4626 "EHLO
	mail2.woosh.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992715AbXCBXKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 18:10:38 -0500
Date: Sat, 3 Mar 2007 12:10:35 +1300 (NZDT)
From: Keith Duthie <keith@no.net.nz>
To: Mike Accetta <maccetta@laurelnetworks.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Someone please turn on the http protocol on git.kernel.org!
In-Reply-To: <45E8220D.9040905@laurelnetworks.com>
Message-ID: <alpine.DEB.0.82.0703031208290.15443@sleipnir.no.net.nz>
References: <7TYYU-5L8-11@gated-at.bofh.it> <7U2zx-392-13@gated-at.bofh.it>
 <45E8220D.9040905@laurelnetworks.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007, Mike Accetta wrote:

> error: Couldn't get
> http://www.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/refs/tags/v2.6.11
> for tags/v2.6.11
> The requested URL returned error: 404
> error: Could not interpret tags/v2.6.11 as something to pull

This would be because the tag v2.6.11 points to a nonexistant object in
the repository.

-- 
The universe hates you, but don't worry - it's nothing personal.
