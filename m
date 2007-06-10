Return-Path: <linux-kernel-owner+w=401wt.eu-S1760448AbXFJUmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760448AbXFJUmu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 16:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbXFJUmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 16:42:43 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:4638 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbXFJUmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 16:42:43 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Simon Arlott" <simon@fire.lp0.eu>, <jengelh@computergmbh.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: RE: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Sun, 10 Jun 2007 13:42:35 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKEELKEHAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
In-Reply-To: <Pine.LNX.4.64.0706101307060.8723@fbirervta.pbzchgretzou.qr>
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sun, 10 Jun 2007 13:42:59 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sun, 10 Jun 2007 13:43:02 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> http://www.eweek.com/article2/0,1759,1915720,00.asp
> has the answer. Quoting Linus:
>
> "If you want to license a program under any later version of the
> GPL, you have
> to state so explicitly. Linux never did."
>
> Hence, unless there's a "GPL 2 or later", all the "unspecified GPL" files
> are GPL2 only.

The GPL states the default position:

"If the Program does not specify a version number of this License, you may
choose any version ever published by the Free Software Foundation."

Leaving the question of whether Linus's comment at the top of the license
changes the default:

"Also note that the only valid version of the GPL as far as the kernel is
concerned is _this_ particular version of the license (ie v2, not v2.2 or
v3.x or whatever), unless explicitly otherwise stated."

So we have dueling defaults. The GPL says the default is any version. Linus'
statement at the top of the GPL says the default is v2 only. It's not clear,
at least to me, that there is any clear reason why one should win out over
the other.

DS


