Return-Path: <linux-kernel-owner+w=401wt.eu-S1758984AbXHITMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984AbXHITMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 15:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750732AbXHITMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 15:12:35 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:58849 "EHLO
	fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131AbXHITMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 15:12:34 -0400
Date: Thu, 9 Aug 2007 21:10:36 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: =?unknown-8bit?Q?Hans-J=C3=BCrgen?= Koch <hjk@linutronix.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Documentation files in html format?
Message-ID: <20070809191036.GA23596@electric-eye.fr.zoreil.com>
References: <20070809113122.3aa508e4@oldman.hamilton.local> <200708091508.20626.hjk@linutronix.de> <p73hcn8g25m.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73hcn8g25m.fsf@bingen.suse.de>
User-Agent: Mutt/1.4.2.1i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> :
[...]
> I would say the track record of existing DocBook deployment is not good enough
> to justify further use. Plain html can be converted into all these
> formats easily too and overall it makes a much nicer user experience.

xsltproc converts from docbook to html fast enough (PDF with a docbook
Java/fop toolchain is a different story). Your experience is a bit
outdated.

> Also I would expect much more people will know how to write html versus
> DocBook.

Yes, it is easy to write more or less random html. I'd even prefer plain
utf8 text.

-- 
Ueimor
