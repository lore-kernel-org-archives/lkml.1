Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbYCPWiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbYCPWiW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 18:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbYCPWiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 18:38:15 -0400
Received: from phunq.net ([64.81.85.152]:41595 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752663AbYCPWiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 18:38:14 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Sun, 16 Mar 2008 14:38:05 -0800
User-Agent: KMail/1.9.5
Cc: David Newall <davidn@davidnewall.com>, Willy Tarreau <w@1wt.eu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <47DCB347.2060706@davidnewall.com> <m3k5k28ged.fsf@maximus.localdomain>
In-Reply-To: <m3k5k28ged.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803161538.06282.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 March 2008 15:15, Krzysztof Halasa wrote:
> David Newall <davidn@davidnewall.com> writes:
> > Do you mean it should be replicated with a second ramback?  That would
> > be pretty pointless, since all failure modes would affect both.  It's
> > not like one ramback will survive a crash when the other doesn't.
> 
> It could, in a bit different location maybe, but it isn't a substitute
> for ordered writes.

How so?

Daniel
