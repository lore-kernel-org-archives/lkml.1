Return-Path: <linux-kernel-owner+w=401wt.eu-S1758111AbYHSVMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbYHSVMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 17:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbYHSVMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 17:12:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55018 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbYHSVMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 17:12:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: torvalds@linux-foundation.org
Subject: Re: [GIT]: Networking
Date: Tue, 19 Aug 2008 23:15:47 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <alpine.LFD.1.10.0808190952000.3324@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808191341150.3324@nehalem.linux-foundation.org> <20080819.140458.236030589.davem@davemloft.net>
In-Reply-To: <20080819.140458.236030589.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808192315.48718.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 19 of August 2008, David Miller wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Tue, 19 Aug 2008 13:47:59 -0700 (PDT)
> 
> > Same goes for all the loopback changes. They look like cleanups or feature 
> > enables.
> 
> Those fix a performance regression reported by a real user.

FWIW, they fix the recent regression tracked as
http://bugzilla.kernel.org/show_bug.cgi?id=11316 .

Thanks,
Rafael
