Return-Path: <linux-kernel-owner+w=401wt.eu-S1752662AbZGVQAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbZGVQAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 12:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbZGVQAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 12:00:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751681AbZGVQAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 12:00:13 -0400
Date: Wed, 22 Jul 2009 08:58:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Troy Moure <twmoure@szypr.net>
cc: Krzysztof Oledzki <olel@ans.pl>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       lwn@lwn.net, Ian Lance Taylor <iant@google.com>
Subject: Re: Linux 2.6.27.27
In-Reply-To: <alpine.LFD.2.00.0907220618270.2606@troy-laptop>
Message-ID: <alpine.LFD.2.01.0907220858020.19335@localhost.localdomain>
References: <20090720040655.GA11940@kroah.com> <4A645A45.9060509@ans.pl> <20090720151008.GC10015@suse.de> <alpine.LFD.2.01.0907200848530.13838@localhost.localdomain> <alpine.LNX.1.10.0907202341580.29729@bizon.gios.gov.pl> <alpine.LFD.2.01.0907201504470.19335@localhost.localdomain>
 <alpine.LNX.1.10.0907210831210.29729@bizon.gios.gov.pl> <alpine.LNX.1.10.0907211154480.29729@bizon.gios.gov.pl> <alpine.LFD.2.01.0907210906400.19335@localhost.localdomain> <alpine.LFD.2.01.0907211133010.19335@localhost.localdomain>
 <alpine.LFD.2.00.0907212211040.4630@troy-laptop> <alpine.LFD.2.01.0907211726140.19335@localhost.localdomain> <alpine.LFD.2.01.0907211759180.19335@localhost.localdomain> <alpine.LFD.2.00.0907220618270.2606@troy-laptop>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 22 Jul 2009, Troy Moure wrote:
> 
> Obviously I got a bit lucky that problem was actually basically where I 
> started looking for it.  But I figured even if I didn't find it, I'd learn 
> something about the radeonfb code. And who would pass up an opportunity to 
> learn about that?

Who indeed? <eyeroll> There are few things more interesting than looking 
at assembler code from the frame buffer layer. </eyeroll>

		Linus
