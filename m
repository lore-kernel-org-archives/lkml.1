Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbYKQTuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbYKQTuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 14:50:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbYKQTt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 14:49:56 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:28148 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbYKQTty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 14:49:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JVvgWb5TLL7BAtF1K4lLaZ99HOUU23I5cRGQQKgxd9KVBGUtt11SUWxr2NrFf19h5N
         1tl+t7IEG345fSrHM06lzQWMirN2fVg4+zj2QtSRofXwtbphgDGbO5dQvmYuOv8QN+VY
         zAdlf7GC6z3E9JCKQMUi6GrZMcdfDdoBbMBTM=
Date: Mon, 17 Nov 2008 22:49:51 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@lusi.uni-sb.de>,
       Glauber Costa <gcosta@redhat.com>
Subject: Re: [RFC] x86: save_args out of line
Message-ID: <20081117194951.GC9944@localhost>
References: <1226845741-12470-1-git-send-email-heukelum@fastmail.fm> <1226845741-12470-2-git-send-email-heukelum@fastmail.fm> <20081117125317.GK6703@one.firstfloor.org> <1226936257.32609.1285214311@webmail.messagingengine.com> <20081117182340.GN6703@one.firstfloor.org> <20081117192216.GA9944@localhost> <1226951006.21581.1285268501@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226951006.21581.1285268501@webmail.messagingengine.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Alexander van Heukelum - Mon, Nov 17, 2008 at 08:43:26PM +0100]
| http://www.fastmail.fm - A fast, anti-spam email service.
| 
...
(me: gone out in deep shame)

		- Cyrill -
