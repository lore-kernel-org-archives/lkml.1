Return-Path: <linux-kernel-owner+w=401wt.eu-S934025AbZJGNWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934025AbZJGNWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 09:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933737AbZJGNWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 09:22:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42468 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933727AbZJGNWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 09:22:46 -0400
Subject: Re: [PATCH] kconfig: simplification of scripts/extract-ikconfig
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Dick Streefland <dick@streefland.net>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <20091007084135.GA5355@streefland.net>
References: <20091006203540.GA14634@streefland.net>
	 <1254881503.1696.115.camel@gandalf.stny.rr.com>
	 <20091007084135.GA5355@streefland.net>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 07 Oct 2009 09:20:47 -0400
Message-Id: <1254921647.1696.135.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 10:41 +0200, Dick Streefland wrote:
> On Tuesday 2009-10-06 22:11, Steven Rostedt wrote:
> | Now the question is, is this something that we should try to get into
> | the 32 release, or let this version go through linux-next for another
> | release?
> 
> I don't have a strong preference, as long as it gets into the kernel
> tree in the end. I realize that it is a bit late in the 32 release
> cycle, but on the other hand this script is not used in the kernel
> build process.

I'm sure it is fine, but since we are after the merge window, I'll push
this off to linux-next.

Thanks,

-- Steve


