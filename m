Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252AbZJERyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbZJERyx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 13:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754164AbZJERyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 13:54:53 -0400
Received: from mail-ew0-f217.google.com ([209.85.219.217]:65518 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776AbZJERyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 13:54:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=D1Tq6J18ZgJuAIBZzfqSVeX3bqhJGLqXtXgJ/sngu1EZ/BbypnlB1879QA3i86IEs8
         Sq6L99DvmfJ7TbU0ZjzGD5xtNeXx3jpSwidGAW1ysxP9i7cj/z7NdoqJ9KbwIZ3wJjcV
         0YeDo1S8jfbvsprrsZKX0vTfT5zVd3FheIYAQ=
Date: Mon, 5 Oct 2009 19:54:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL] tracing: Perf tracing fixes
Message-ID: <20091005175411.GA5218@nowhere>
References: <19140.13582.223629.56214@cargo.ozlabs.ibm.com> <1254577650-5623-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254577650-5623-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 03, 2009 at 03:47:28PM +0200, Frederic Weisbecker wrote:
> Ingo,
> 
> Please pull these .33 tracing fixes from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	tracing/core
> 


I've rebased it against latest Linus, you can pull it from

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/urgent

Thanks!

Frederic.

