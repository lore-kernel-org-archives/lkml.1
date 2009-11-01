Return-Path: <linux-kernel-owner+w=401wt.eu-S1753407AbZKAU2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbZKAU2v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 15:28:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbZKAU2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 15:28:50 -0500
Received: from lo.gmane.org ([80.91.229.12]:59111 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382AbZKAU2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 15:28:50 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Subject: Re: FatELF patches...
Date: Sun, 01 Nov 2009 20:28:27 +0000
Message-ID: <yw1xy6mq0z2s.fsf@unicorn.mansr.com>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan> <1257103201.2865.6.camel@chumley>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: unicorn.mansr.com
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.22 (Instant Classic, linux)
Cancel-Lock: sha1:DeT0EJDpKRMwED9u4SLzyeS8yMY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Hagood <david.hagood@gmail.com> writes:

> On Thu, 2009-10-29 at 22:19 -0400, Ryan C. Gordon wrote:
>> Having heard a bunch of commentary, and made a bunch of changes based on 
>> some really good feedback, here are my hopefully-final FatELF patches.
>
> I hope it's not too late for a request for consideration: if we start
> having fat binaries, could one of the "binaries" be one of the "not
> quite compiled code" formats like Architecture Neutral Distribution
> Format (ANDF), such that, given a fat binary which does NOT support a
> given CPU, you could at least in theory process the ANDF section to
> create the needed target binary? Bonus points for being able to then
> append the newly created section to the file.

Am I the only one who sees this as nothing bloat for its own sake?
Did I miss a massive drop in intelligence of Linux users, causing them
to no longer be capable of picking the correct file themselves?

> As an embedded systems guy who is looking to have to support multiple
> CPU types, this is really very interesting to me.

As an embedded systems guy, I'm more concerned about precious flash
space going to waste than about some hypothetical convenience.

-- 
Måns Rullgård
mans@mansr.com

