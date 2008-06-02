Return-Path: <linux-kernel-owner+w=401wt.eu-S1756646AbYFBPwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbYFBPwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 11:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbYFBPvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 11:51:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbYFBPvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 11:51:54 -0400
Date: Mon, 2 Jun 2008 11:51:33 -0400
From: Alan Cox <alan@redhat.com>
To: Joe Peterson <joe@skyrush.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Newall <davidn@davidnewall.com>,
       Willy Tarreau <w@1wt.eu>, Harald Dunkel <harald.dunkel@t-online.de>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>
Subject: Re: 2.6.25.3: su gets stuck for root
Message-ID: <20080602155133.GC933@devserv.devel.redhat.com>
References: <48434D57.6030801@skyrush.com> <48438126.3080308@t-online.de> <20080602053256.GF5609@1wt.eu> <20080602091016.571dda7c@core> <4843B6EE.8080104@davidnewall.com> <20080602102033.63e4cd18@core> <48441138.90503@skyrush.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48441138.90503@skyrush.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2008 at 09:26:48AM -0600, Joe Peterson wrote:
> P.S.  My stty process sits in "T" - did you say that it would be in "R"
> if straced and that is correct?

T would be correct. I'll put together a small diff to printk useful stuff
when it happens and sent it you tonight/tomorrow


-- 
--
                Take control of enterprise infrastructure
                   Sign up for starfleet academy today
