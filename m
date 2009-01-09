Return-Path: <linux-kernel-owner+w=401wt.eu-S1754940AbZAIK5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbZAIK5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 05:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbZAIK5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 05:57:08 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:43815 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbZAIK5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 05:57:07 -0500
Message-ID: <49672D75.4060201@davidnewall.com>
Date: Fri, 09 Jan 2009 21:26:53 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: jmerkey@wolfmountaingroup.com
CC: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Kernel Blocking Firewall
References: <40416.166.70.238.44.1231467823.squirrel@webmail.wolfmountaingroup.com>    <20090109064658.GG5038@1wt.eu>    <37611.166.70.238.44.1231486566.squirrel@webmail.wolfmountaingroup.com>    <20090109084540.GH5038@1wt.eu>    <40547.166.70.238.44.1231488906.squirrel@webmail.wolfmountaingroup.com>    <20090109090956.GA28484@1wt.eu> <55312.166.70.238.44.1231490626.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <55312.166.70.238.44.1231490626.squirrel@webmail.wolfmountaingroup.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jmerkey@wolfmountaingroup.com wrote:
> Allowing a server on a dynamic IP range to act as a mail server is what is
> stupid.

Sorry to be argue semantics, but I think it's SMTP clients that are the
major cause of spam.  Many, probably most, ISPs provide an SMTP relay
for their subscribers, and blocking these dynamic addresses doesn't
present a hard impediment for delivery of their mail to you.  None the
less, to say that people on a dynamic IP address should be *obliged* to
go through a relay is offensive.  (Not that you did say that, but I
think it's what you had in mind.)
