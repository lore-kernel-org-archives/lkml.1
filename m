Return-Path: <linux-kernel-owner+w=401wt.eu-S1757922AbYFJVSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922AbYFJVSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753965AbYFJVR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:17:59 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:48808 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749AbYFJVR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:17:58 -0400
Date: Tue, 10 Jun 2008 23:18:41 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Tim Bird <tim.bird@am.sony.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add diffconfig utility
Message-ID: <20080610211841.GA23855@uranus.ravnborg.org>
References: <484ED902.9040000@am.sony.com> <20080610210217.GA2432@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080610210217.GA2432@logfs.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 11:02:18PM +0200, Jörn Engel wrote:
> On Tue, 10 June 2008 12:41:54 -0700, Tim Bird wrote:
> > Delivery-date: Tue, 10 Jun 2008 21:44:08 +0200
> > From: Tim Bird <tim.bird@am.sony.com>
> > To: linux-embedded <linux-embedded@vger.kernel.org>
> > CC: linux kernel <linux-kernel@vger.kernel.org>
> > Subject: [PATCH] add diffconfig utility
> 
> Neat.  But I have one nagging question: who do you expect to merge this
> patch? ;)
I will merge it if the feedabck is positive and eventual feedback
is dealt with. (And Tim reminds me to do so in a week or so).

I take most of the random scripts in scripts/ via kbuild.git.

	Sam
