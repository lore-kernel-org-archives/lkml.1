Return-Path: <linux-kernel-owner+w=401wt.eu-S1755592AbZFCGJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbZFCGJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 02:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbZFCGJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 02:09:41 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:46404 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbZFCGJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 02:09:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ealwP097FceMobxHsfOSdWtEU5AO6OZr2Jpfx30PRNZ8LXEoTDW8VQzHQoBUEEvhI+
         CLFLCeSp9k3+2pJEtsuZj54SHy5qiv2f7Zwu6zu++PctEnW+U+5eXK77ydtUv/iv4kDM
         8kgK885JntMvtNpo2I8VNZQ/0NAScD4//+q4I=
From: Gerard Lledo <gerard.lledo@gmail.com>
Date: Wed, 3 Jun 2009 09:09:37 +0300
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [JFFS2] jffs2_start_garbage_collect_thread() return
	value cleanup
Message-ID: <20090603060937.GA2554@tank>
References: <20090602113216.GA3513@tank> <1243944686-7039-1-git-send-email-gerard.lledo@gmail.com> <1243944686-7039-2-git-send-email-gerard.lledo@gmail.com> <20090602151112.376ca436.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602151112.376ca436.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 03:11:12PM -0700, Andrew Morton wrote:
> On Tue,  2 Jun 2009 15:11:26 +0300
> Gerard Lledo <gerard.lledo@gmail.com> wrote:
> 
> > There is no user of this return value in the kernel.  Change it to return void
> > instead.
> 
> Both these patches were missing your signed-off-by:.  As your first
> version of the first patch wasn't missing it, I added it to both these
> patches, OK?
>

Thats fine.  I just forgot to add it.  Thanks, and sorry for the trouble/noise.
