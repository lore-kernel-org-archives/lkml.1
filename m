Return-Path: <linux-kernel-owner+w=401wt.eu-S932956AbYBMQP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956AbYBMQP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 11:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762642AbYBMQPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 11:15:15 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:49889 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932351AbYBMQPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 11:15:13 -0500
Date: Wed, 13 Feb 2008 08:14:14 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ferenc Wagner <wferi@niif.hu>
Cc: "Mike Snitzer" <snitzer@gmail.com>, linux-kernel@vger.kernel.org,
       "Willy Tarreau" <w@1wt.eu>
Subject: Re: currently active Linux kernel versions
Message-Id: <20080213081414.f97fc5fe.randy.dunlap@oracle.com>
In-Reply-To: <87fxvxpb0s.fsf@szonett.ki.iif.hu>
References: <87skzx53a9.fsf@szonett.ki.iif.hu>
	<1202850783.6697.0.camel@bip.parateam.prv>
	<87wsp9q3ev.fsf@szonett.ki.iif.hu>
	<170fa0d20802121337t35787cbby52286f5a08ea2e15@mail.gmail.com>
	<87fxvxpb0s.fsf@szonett.ki.iif.hu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 08:32:03 +0100 Ferenc Wagner wrote:

> "Mike Snitzer" <snitzer@gmail.com> writes:
> 
> > 2.6.23.x and 2.6.24.x are obviously quite active for stable@kernel.org
> 
> What is stable@kernel.org?  That sounds promising.  The closest I
> could find is stable-commits@vger.kernel.org.

stable@kernel.org is the mailing address to send patches that
should be applied to a stable kernel series.  From the
MAINTAINERS file:

STABLE BRANCH:
P:	Greg Kroah-Hartman
M:	greg@kroah.com
P:	Chris Wright
M:	chrisw@sous-sol.org
L:	stable@kernel.org
S:	Maintained


---
~Randy
