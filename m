Return-Path: <linux-kernel-owner+w=401wt.eu-S1755632AbYHMXcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632AbYHMXcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 19:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbYHMXcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 19:32:39 -0400
Received: from nfitmail.nfit.au.dk ([130.225.31.129]:28564 "EHLO
	smtp.nfit.au.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751626AbYHMXci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 19:32:38 -0400
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Aug 2008 19:32:38 EDT
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: sysprof in 2.6.27 kernel
References: <20080813083953.GF19333@ics.muni.cz>
From: Soeren Sandmann <sandmann@daimi.au.dk>
Date: 14 Aug 2008 01:23:16 +0200
In-Reply-To: <20080813083953.GF19333@ics.muni.cz>
Message-ID: <ye8myjg7b4r.fsf@camel10.daimi.au.dk>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Hejtmanek <xhejtman@ics.muni.cz> writes:

> Hello,
> 
> is there any port of sysprof gui that cooperates with the current 2.6.27 kernel
> sysprof tracer?

Yes, the port is accessible from here:

    svn checkout http://svn.gnome.org/svn/sysprof/branches/ftrace-branch sysprof

It's somewhat rough still. If you try it out, I will be interested in
any feedback you have.


Thanks,
Soren
