Return-Path: <linux-kernel-owner+w=401wt.eu-S932358AbXIFP1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358AbXIFP1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 11:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756443AbXIFP06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 11:26:58 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:16753 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107AbXIFP04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 11:26:56 -0400
Subject: Re: [PATCH 0/3] build system: section garbage collection for
	vmlinux
From: Daniel Walker <dwalker@mvista.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: sam@ravnborg.org, kai@germaschewski.name, linux-kernel@vger.kernel.org
In-Reply-To: <200709061157.44080.vda.linux@googlemail.com>
References: <200709051443.21522.vda.linux@googlemail.com>
	 <200709052049.30649.vda.linux@googlemail.com>
	 <1189021619.4442.36.camel@imap.mvista.com>
	 <200709061157.44080.vda.linux@googlemail.com>
Content-Type: text/plain
Date: Thu, 06 Sep 2007 08:13:50 -0700
Message-Id: <1189091630.8490.1.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-06 at 11:57 +0100, Denys Vlasenko wrote:
> On Wednesday 05 September 2007 20:46, Daniel Walker wrote:
> > On Wed, 2007-09-05 at 20:49 +0100, Denys Vlasenko wrote:
> > 
> > > What does "it" stand for in this sentence?
> > 
> > "it" is your patches, and I think we got to bottom of it .. "it" (i.e.
> > your patches) don't actually work with modules, which is what you
> > originally contended ..
> 
> Kernel builds, loads and runs with my patches, and modules load just fine.

Ok, so I guess we're not clear on this point .. In your last email you
said that module exports might get removed? Is that what you intended to
say or not?

Daniel

