Return-Path: <linux-kernel-owner+w=401wt.eu-S1752000AbYLOMmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbYLOMmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 07:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750902AbYLOMmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 07:42:09 -0500
Received: from fmmailgate05.web.de ([217.72.192.243]:37532 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbYLOMmI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 07:42:08 -0500
Date: Mon, 15 Dec 2008 13:42:06 +0100
Message-Id: <543076374@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: problem with git.kernel.org
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX18LP9wm0cYrWLj6H6XYpIp6/zcQJhFK4coE5c3IluNn5ZX6F
 GBXJy2cWKzNhHSCnG7djQy4TR7e9rQcYKrXuBkViUvScQzGhmk=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> devzero@web.de wrote:
> > I´m trying to download a btrfs snapshot via http ( http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable-standalone.git;a=snapshot;h=HEAD
> > )  to be able to try btrfs with current kernel, but i get no tar.gz but just see "Generating....." for a long time and then getting a timeout.
> > 
> > this seems to apply to all git repositories hosted on kernel.org.
> > 
> > For comparison, this one behaves as expected:
> > http://gitweb.opencompositing.org/?p=fusion/decorators/emerald;a=snapshot;h=HEAD
> 
> The kernel repo is more than 100 times as big as this emerald repo, 400
> times as big perhaps.  

yes, but http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable-standalone.git is a small repository, just containing the btrfs driver.  even if kernel repo is 100 times bigger, i don`t see the point why this should not work. if it puts too much load on the server and/or doesn`t work anyway, then it`s better to disable that instead of letting stupid users like me waste their time with that ;)

> Try to download with git.

i did, but it didn`t work either. i`m behind a http proxy. that`s why i chose the gitweb option.

> > As there is no adress how to contact, can someone confirm and/or please forward this mail to the gitweb admin ?
> 
> www.kernel.org lists a contact address.

ok, i assume you mean ftpadmin and webmaster then....

regards
roland

____________________________________________________________________
Psssst! Schon vom neuen WEB.DE MultiMessenger gehört? 
Der kann`s mit allen: http://www.produkte.web.de/messenger/?did=3123

