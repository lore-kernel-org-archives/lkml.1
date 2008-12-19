Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbYLSJho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbYLSJho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 04:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbYLSJhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 04:37:35 -0500
Received: from styx.suse.cz ([82.119.242.94]:50502 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751361AbYLSJhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 04:37:34 -0500
Date: Fri, 19 Dec 2008 10:37:33 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jirislaby@gmail.com>
cc: Hannes Eder <hannes@hanneseder.net>, Ben Dooks <ben-linux@fluff.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] HID: avoid sparse warning in HID_COMPAT_LOAD_DRIVER
In-Reply-To: <494B5BC4.100@gmail.com>
Message-ID: <alpine.LNX.1.10.0812191037110.26265@jikos.suse.cz>
References: <4947a48f.08b6660a.34ca.ffffa1e8@mx.google.com>  <20081216155822.GD12431@fluff.org.uk>  <alpine.LNX.1.10.0812161659580.21089@jikos.suse.cz>  <20081216194113.GF12431@fluff.org.uk> <154e089b0812161144x3c9579f5g8731b616fde6484c@mail.gmail.com>
 <494B5BC4.100@gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2008, Jiri Slaby wrote:

> > But, don't ask my why the void functions with empty function bodies 
> > are exported.
> Because of autoload to create a dependency. Note that this is a temporary
> solution to workaround the non-presence of hid bus in module-init-tools and will
> be removed in next few releases.

BTW while we are at it -- what is the status with module-init-tools? Has 
the support been merged already?

Thanks,

-- 
Jiri Kosina
SUSE Labs
