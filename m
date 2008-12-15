Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbYLOKXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbYLOKXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 05:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbYLOKXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 05:23:04 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:50766 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbYLOKXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 05:23:03 -0500
Message-ID: <49462FF1.2040104@s5r6.in-berlin.de>
Date: Mon, 15 Dec 2008 11:22:41 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.17) Gecko/20080829 SeaMonkey/1.1.12
MIME-Version: 1.0
To: devzero@web.de
CC: linux-kernel@vger.kernel.org
Subject: Re: problem with git.kernel.org
References: <542818697@web.de>
In-Reply-To: <542818697@web.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devzero@web.de wrote:
> I´m trying to download a btrfs snapshot via http ( http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable-standalone.git;a=snapshot;h=HEAD
> )  to be able to try btrfs with current kernel, but i get no tar.gz but just see "Generating....." for a long time and then getting a timeout.
> 
> this seems to apply to all git repositories hosted on kernel.org.
> 
> For comparison, this one behaves as expected:
> http://gitweb.opencompositing.org/?p=fusion/decorators/emerald;a=snapshot;h=HEAD

The kernel repo is more than 100 times as big as this emerald repo, 400
times as big perhaps.  Try to download with git.

> As there is no adress how to contact, can someone confirm and/or please forward this mail to the gitweb admin ?

www.kernel.org lists a contact address.
-- 
Stefan Richter
-=====-==--- ==-- -====
http://arcgraph.de/sr/
