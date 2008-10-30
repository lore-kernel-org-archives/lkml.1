Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbYJ3Pvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbYJ3Pvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 11:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbYJ3Pve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 11:51:34 -0400
Received: from gv-out-0910.google.com ([216.239.58.186]:34327 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbYJ3Pvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 11:51:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VyW8I/PMjyc6iYR6wj13f8ucJ2N/ILna0UxdLJIT3WkJblr2us876G/e0mFZYRB/ze
         ldWTWqUF4zmAAGn1yVdOqnqy03PjRcpUvJ1yCwijP8TTF2gDythjPQlQUq4UsxYfuoLJ
         pUlQLvkBKHBwOEsnUntaG01HHuLKJ8hDnMq6A=
Date: Thu, 30 Oct 2008 18:51:27 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Aristeu Rozanski <aris@redhat.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] nmi_watchdog: update procfs nmi_watchdog file
	documentation
Message-ID: <20081030155127.GB19888@localhost>
References: <20081030151712.GO771@redhat.com> <20081030154534.GA19888@localhost> <20081030155120.GP771@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030155120.GP771@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Aristeu Rozanski - Thu, Oct 30, 2008 at 11:51:21AM -0400]
| > Hi Aristeu,
| > 
| > by reading this patch I found that maybe it's time to start
| > using nmi_watchdog=[lapic,ioapic] instead of 1 and 2? We could make
| > them as alases to existing numbers. Thoughts?
| Yes, that would be useful.
| 
| -- 
| Aristeu
| 

ok, will handle it :)

		- Cyrill -
