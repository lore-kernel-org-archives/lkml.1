Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbYAZEBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbYAZEBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 23:01:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbYAZEBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 23:01:42 -0500
Received: from victoria.magic.fr ([62.210.190.6]:53174 "EHLO victoria.magic.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbYAZEBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 23:01:41 -0500
X-Greylist: delayed 1621 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jan 2008 23:01:41 EST
From: "Didier" <dgautheron@magic.fr>
To: Michael Monnerie <michael.monnerie@it-management.at>,
       netatalk-admins@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Netatalk-admins] netatalk slow after system upgrade (possibly kernel problem?)
Date: Sat, 26 Jan 2008 04:33:25 +0100
Message-Id: <20080126031553.M81123@magic.fr>
In-Reply-To: <200801251255.48105@zmi.at>
References: <200801251255.48105@zmi.at>
X-Mailer: WebMail Magic OnLine 7.19
X-MoL: WebMail/Victoria/OWM
X-OriginatingIP: Magic OnLine / 82.227.66.77 / dgautheron@webmail.magic.fr
MIME-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Fri, 25 Jan 2008 12:55:42 +0100, Michael Monnerie wrote
> Dear lists,
> 
> I've been spending a LOT of time trying to find out where's the 
> problem, but can't find it and therefore seek urgent help now. We 
> have the following system:
Did you try to force the server MTU to 1500 (it looks like you have jumbo
frame enabled) ?

Some interesting TCP/IP packets though :) 
 
OT as it was working before but if it's a simple LAN you may have a flaky/wire
in the loop too.

Didier

