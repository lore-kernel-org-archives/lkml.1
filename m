Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466AbYJDUkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbYJDUkI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 16:40:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbYJDUj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 16:39:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:35983 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbYJDUjz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 16:39:55 -0400
Date: Sat, 4 Oct 2008 13:39:40 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "=?UTF-8?B?RnLDqWTDqXJpYw==?= Weisbecker" <fweisbec@gmail.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       alan-jenkins@tuffmail.co.uk
Subject: Re: [PATCH -tip] Fastboot: fix initcalls disposition in
 bootgraph.pl
Message-ID: <20081004133940.44feb2a0@infradead.org>
In-Reply-To: <c62985530810041328i282818cak8cd0ba36c450e3d6@mail.gmail.com>
References: <48E7C594.4030400@gmail.com>
	<20081004131901.66720416@infradead.org>
	<c62985530810041328i282818cak8cd0ba36c450e3d6@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Oct 2008 22:28:49 +0200
"Frédéric Weisbecker" <fweisbec@gmail.com> wrote:

> I'm tracing all of the initcalls in my machine (even the modules).
> If you look at both svg sources, you will see all of the 5 initcalls
> displayed. But for the "before the patch" one, it depends on the
> software you are using to visualize it.
> With firefox you only see two of them. With the default gnome
> visualization software (don't remember its name)
> you can see all of them but in a very extensive image because a lot of
> rows are unused.
> 
> With the "after the patch one", there is no issues....

fair enough

Acked-by: Arjan van de Ven <arjan@linux.intel.com>

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
