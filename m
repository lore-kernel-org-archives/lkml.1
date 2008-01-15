Return-Path: <linux-kernel-owner+w=401wt.eu-S1757274AbYAOXSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbYAOXSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 18:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112AbYAOXSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 18:18:34 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:59336 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbYAOXSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 18:18:34 -0500
Date: Tue, 15 Jan 2008 15:17:21 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: where to maintain userspace daemon for line discipline
Message-Id: <20080115151721.5ef18af2.randy.dunlap@oracle.com>
In-Reply-To: <478D3BCF.9020904@imap.cc>
References: <45AE507E.3040601@imap.cc>
	<20070122115644.b538908f.akpm@osdl.org>
	<45CA4D32.6010302@zytor.com>
	<478D3BCF.9020904@imap.cc>
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

On Wed, 16 Jan 2008 00:03:43 +0100 Tilman Schmidt wrote:

> Hi,
> 
> On Wed, 07 Feb 2007 14:05:38 -0800, H. Peter Anvin wrote:
> > util-linux-ng is already going, so it's a good place.
> 
> Not even a year later, I'd like to take up this proposal. I have:
> - gigasetm101d.c (the source program)
> - gigasetm101d.8 (a manpage)
> - Makefile (trivial)
> How should I proceed in order to get this included in util-linux-ng?

See http://userweb.kernel.org/~kzak/util-linux-ng/
for all util-linux-ng info, including mailing list.

---
~Randy
