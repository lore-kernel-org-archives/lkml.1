Return-Path: <linux-kernel-owner+w=401wt.eu-S1758238AbXFLFor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238AbXFLFor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 01:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbXFLFok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 01:44:40 -0400
Received: from max.aladin.ro ([80.96.155.2]:34217 "EHLO aladin.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbXFLFoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 01:44:39 -0400
Message-ID: <466E32C5.70105@aladin.ro>
Date: Tue, 12 Jun 2007 08:44:37 +0300
From: Eduard-Gabriel Munteanu <maxdamage@aladin.ro>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] UML: fix missing non-blocking I/O, now DEBUG_SHIRQ
 works
References: <1181512917.3157.8.camel@localhost> <20070611173154.GA6889@c2.user-mode-linux.org> <466DA50C.5050301@aladin.ro> <20070611211604.GA8859@c2.user-mode-linux.org> <466DCF1D.9050508@aladin.ro> <20070612004804.GA9871@c2.user-mode-linux.org>
In-Reply-To: <20070612004804.GA9871@c2.user-mode-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

*This message was transferred with a trial version of CommuniGate(r) Pro*
Jeff Dike wrote:
> No it won't.  UML builds without warnings here on x86_64.

Okay, I don't have an x86_64, sparc64 or something similar, as my 
computer is an x86, so I can't contradict this. If everything is fine on 
such arches, no fix is needed when nothing's broken... though I still 
think it's kind of ugly (though it's somehow ingenious as a hack) :)

Do you want me to resubmit the patch without these changes? I'll be back 
in a few hours (got to go now) and trim this out from the patch if 
that's necessary.
