Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbYJVPiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbYJVPiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 11:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbYJVPih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 11:38:37 -0400
Received: from lazybastard.de ([212.112.238.170]:58527 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbYJVPig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 11:38:36 -0400
Date: Wed, 22 Oct 2008 17:38:09 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>, sfr@canb.auug.org.au,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: Sending patches, against linux-next.git, linux-2.6.git or what?
Message-ID: <20081022153808.GC25283@logfs.org>
References: <48FEAD30.3090906@lougher.demon.co.uk> <20081021231757.7cf40e23.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081021231757.7cf40e23.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 October 2008 23:17:57 -0700, Andrew Morton wrote:
> 
> A much bigger
> task is getting them reviewed and generally getting a bit of
> momentum/interest/enthusiasm/etc.

How much of that is needed?  Squashfs is very widely used and the
current work is _much_ better than it used to be.  There is some work
remaining to be done, but the current format appears sane.

I'd vote to merge this fairly soon.

Jörn

-- 
All art is but imitation of nature.
-- Lucius Annaeus Seneca
