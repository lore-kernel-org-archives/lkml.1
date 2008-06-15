Return-Path: <linux-kernel-owner+w=401wt.eu-S1756006AbYFOGVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbYFOGVg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 02:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbYFOGVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 02:21:30 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:44207 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751391AbYFOGVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 02:21:30 -0400
Message-ID: <4854B4E4.1060903@davidnewall.com>
Date: Sun, 15 Jun 2008 15:51:24 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jgarzik@pobox.com>, netdev@vger.kernel.org,
       Trivial Patch Monkey <trivial@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] 8139too: clean up spaces and TABs
References: <4853BB62.1060109@freemail.hu> <4853C8AD.9020407@s5r6.in-berlin.de> <48541165.7050304@freemail.hu>
In-Reply-To: <48541165.7050304@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches, which simply play around with white space, are
undesirable, in my opinion.  It doesn't make the code better, just
changes the aesthetics to one that's more to your liking, and surely it
makes it less pleasing to others.  I see no benefit in such changes, as
opposed to a certain cost and risk, which all changes carry.  Every
change requires an expense of other people's brain cycles, if I can put
it that way, and on this sort of change, I sincerely think it's pointless.

Sorry to come down all negative.
