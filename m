Return-Path: <linux-kernel-owner+w=401wt.eu-S937381AbYEBXRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937381AbYEBXRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 19:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932417AbYEBXR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 19:17:29 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:48525 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762397AbYEBXR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 19:17:28 -0400
Date: Fri, 2 May 2008 17:17:27 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: [PATCH] Extend list debugging to cover hlists
Message-ID: <20080502231727.GQ14976@parisc-linux.org>
References: <20080502182745.GL14976@parisc-linux.org> <20080502161403.fe596cca.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080502161403.fe596cca.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 04:14:03PM -0700, Andrew Morton wrote:
> linux-next is a better tree against which to prepare 2.6.x+1 patches.

Is there a reason to wait for 2.6.x+1?  People are having problems today
with corrupt hlists.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
