Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbYIZWWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbYIZWWG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 18:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbYIZWVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 18:21:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35322 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbYIZWVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 18:21:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: D945GCLF  intel atom board & r8169 ethernet broken in linux-2.6.27-rc5??
Date: Sat, 27 Sep 2008 00:27:30 +0200
User-Agent: KMail/1.9.9
Cc: John Gumb <john.gumb@tandberg.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, "Kok, Auke" <auke-jan.h.kok@intel.com>
References: <9F6ACAE02B6DD040A1E259977622CFDB03F5BCCB@oslexcp1.eu.tandberg.int> <200809262345.47373.rjw@sisk.pl> <20080926215211.GA26065@electric-eye.fr.zoreil.com>
In-Reply-To: <20080926215211.GA26065@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809270027.31037.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 26 of September 2008, Francois Romieu wrote:
> Rafael J. Wysocki <rjw@sisk.pl> :
> > On Wednesday, 24 of September 2008, Francois Romieu wrote:
> [...]
> > > Can you try patches #0001 .. #0008 at
> > > http://userweb.kernel.org/~romieu/r8169/2.6.27-rc6/20080913/ ?
> > 
> > FWIW, these patches make the Ethernet card in the MSI Wind I've been recently
> > testing work much much more reliably. :-)
> 
> The whole series or a part of it ?

I've only tried all of them at once.
