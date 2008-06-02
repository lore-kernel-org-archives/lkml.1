Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbYFBUuC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbYFBUuC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 16:50:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbYFBUtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 16:49:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:53629 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbYFBUtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 16:49:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SgQ2tfVLb6QN5FiHHbCke6XgBk/R1hnBxBbUvEuSbqx8UxN09EvFJ3Z/0OcgtHdPGy
         zlz2KGiTzZebLItJdxgFe+NgZIq0lZBTWosUhIi7IdfPr56tCl4J352c+o2kJZClpVsI
         0aW4bz29IuRmwbJIOCqJSVNZHN6NxlmC/qVbg=
Date: Tue, 3 Jun 2008 00:49:43 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Wim Van Sebroeck <wim@iguana.be>,
       Scott Wood <scottwood@freescale.com>,
       Andrew Morton <akpm@linux-foundation.org>, Jochen@ozlabs.org
Subject: Re: [PATCH 1/8] [WATCHDOG] mpc83xx_wdt: fix checkpatch issues
Message-ID: <20080602204943.GA7255@zarina>
Reply-To: cbouatmailru@gmail.com
References: <20080602173726.GA24556@polina.dev.rtsoft.ru> <20080602173836.GA30705@polina.dev.rtsoft.ru> <20080602204318.4cb77070@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080602204318.4cb77070@core>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2008 at 08:43:18PM +0100, Alan Cox wrote:
> On Mon, 2 Jun 2008 21:38:36 +0400
> Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > Quite tired of these warnings ;-), checkpatch spitting them when
> > seeing the rename patch.
> 
> I've already sent the maintainer a complete overhaul of watchdog via
> checkpatch.

Oh, I see it now, thanks. I've just read Wim's comments there, and I
think I'll have to wait for git-watchdog update and then will rebase my
work on top.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
