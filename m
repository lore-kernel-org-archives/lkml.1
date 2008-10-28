Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004AbYJ1Rsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbYJ1Rsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 13:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754884AbYJ1RsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 13:48:20 -0400
Received: from mail-gx0-f18.google.com ([209.85.217.18]:62692 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbYJ1RsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:48:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jyAPhwm7K8qg2VZBcj6nYmEeUxJfbKAv0zc0ZNmf4bR1H7HtOAeSi4pX+L5osDsGm4
         oWS7/wL1xhIO8TyBMIzJV3NhFQJjwvVgfQqoPcmC5ynbTFYl7WFtgo8vyqM2mrYk4Fm8
         TmyBdcsH/ff/1rPWru+2cdRwEL3ln9wpRx6UQ=
Date: Tue, 28 Oct 2008 20:48:13 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix init_memory_mapping for [dc000000 - e0000000)
Message-ID: <20081028174813.GB7357@localhost>
References: <490406FD.30604@kernel.org> <20081027165028.GB30573@linux-os.sc.intel.com> <20081027175547.GE3046@elte.hu> <49067058.7010106@kernel.org> <20081028092737.GT15734@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081028092737.GT15734@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Tue, Oct 28, 2008 at 10:27:37AM +0100]
| 
| * Yinghai Lu <yinghai@kernel.org> wrote:
| 
| > Impact: fix range calculation
| 
| applied to tip/x86/urgent, thanks Yinghai!
| 
| i changed the impact line to:
| 
| Impact: change over-mapping to precise mapping, fix /proc/meminfo output
| 
| 	Ingo
| 

When we started to use Impact: line? I mean -- now we have
to use it? Just noticed this word in patches a day or maybe
several day ago -- so it seem to be quite freshy :)

		- Cyrill -
