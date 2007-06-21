Return-Path: <linux-kernel-owner+w=401wt.eu-S1757189AbXFUS36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbXFUS36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 14:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbXFUS3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 14:29:49 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1790 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbXFUS3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 14:29:48 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: how about mutual compatibility between Linux's GPLv2 and GPLv3?
Date: Thu, 21 Jun 2007 11:29:17 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKMEHNEMAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <orlkedpryc.fsf@oliva.athome.lsd.ic.unicamp.br>
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 21 Jun 2007 11:29:48 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 21 Jun 2007 11:29:50 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Alexandre Oliva wrote:

> However, if GPLv3 had a permission to combine/link with code under
> GPLv2, *and* Linux (and any other projects interested in mutual
> compatibility) introduced an additional permission to combine/link
> with code under GPLv3 (or even GPLv3+, constrained by some condition
> if you will), then:

Wouldn't that defeat the entire purpose of the GPLv3? Couldn't I take any
GPLv3 program, combine it with a few lines of Linux code, and Tivoize the
result?

The fundamental problem is this: Any proposed mutually compatible license
must either permit or prohibit Tivoization. If it prohibits it, then it's no
different from changing the kernel license to GPLv3. If it allows it, then
it's no different from the GPLv2 and it would be suicide to the whole
purpose of the GPLv3 for it to be compatible with it.

DS


