Return-Path: <linux-kernel-owner+w=401wt.eu-S1761876AbYBFLjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761876AbYBFLjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 06:39:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762480AbYBFLjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 06:39:35 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:1796 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762458AbYBFLje convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 06:39:34 -0500
From: "David Schwartz" <davids@webmaster.com>
To: "Pavel Roskin" <proski@gnu.org>
Cc: <rms@gnu.org>, <linux-kernel@vger.kernel.org>, <jonathan@jonmasters.org>,
       <rusty@rustcorp.com.au>, <pgiri@yahoo.com>
Subject: RE: ndiswrapper and GPL-only symbols redux
Date: Wed, 6 Feb 2008 03:38:52 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKGEAHKCAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20080206105051.GA13874@cs181133002.pp.htv.fi>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Wed, 06 Feb 2008 03:40:11 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Wed, 06 Feb 2008 03:40:13 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Adrian Bunk wrote:

> The Linux kernel is licenced under the GPLv2.
> 
> Ndiswrapper loads and executes code with not GPLv2 compatible licences 
> in a way in the kernel that might be considered similar to a GPLv2'ed 
> userspace program dlopen() a dynamic library file with a not GPLv2 
> compatible licence.
> 
> IANAL, but I do think there might be real copyright issues with 
> ndiswrapper.

Neither the kernel+ndiswrapper nor the non-free driver were developed with knowledge of the other, so there is simply no way one could be a derivative work of the other. Since no creative effort is required to link them together, and the linked result is not fixed in a permanent medium, a derivative work cannot be created by the linking process itself.

In any event, even if it was, this is the normal use of ndiswrapper, and normal use cannot be encumbered by copyright. Otherwise, it would be unwise to color in a coloring book.

So if there is a possible copyright issue, I for one can't imagine what it could be. There simply *cannot* be a copyright issue when one merely uses a work in the normal, intended and expected way.

DS


