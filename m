Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbZKROi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbZKROi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:38:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757273AbZKROiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:38:55 -0500
Received: from ns.penguin.cz ([84.21.108.25]:36851 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757282AbZKROiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:38:54 -0500
Subject: Re: 2.6.32-rc7: compile regression on spitz
From: Stanislav Brabec <utx@penguin.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20091118090100.GA1399@ucw.cz>
References: <20091118090100.GA1399@ucw.cz>
Content-Type: text/plain; charset="ISO-8859-2"
Date: Wed, 18 Nov 2009 15:38:53 +0100
Message-Id: <1258555133.3454.2.camel@hammer.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> If CONFIG_AKITA is not set, spitz fails to compile. It worked ok in
> rc5. Fix is one more ifdef...

That was my mistake in 5e0fa3f.

> Signed-off-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Stanislav Brabec <utx@penguin.cz>

-- 
Stanislav Brabec
http://www.penguin.cz/~utx

