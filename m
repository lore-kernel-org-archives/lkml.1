Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbYGYMwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbYGYMwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 08:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbYGYMwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 08:52:08 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:53188 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbYGYMwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 08:52:07 -0400
Message-ID: <4889CC4B.1090406@s5r6.in-berlin.de>
Date: Fri, 25 Jul 2008 14:51:23 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
CC: Grant Coady <gcoady.lk@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: how much stuff is no longer "EXPERIMENTAL"?
References: <alpine.LFD.1.10.0807241114000.4119@localhost.localdomain> <h2ih845fmasm3coi3qapmqkknj0ghp6k7t@4ax.com> <alpine.LFD.1.10.0807241606240.6474@localhost.localdomain>
In-Reply-To: <alpine.LFD.1.10.0807241606240.6474@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> at last count, there were 437 config selections that were tagged as
> EXPERIMENTAL.

drivers/ieee1394/Kconfig and drivers/firewire/Kconfig contain three
dependencies on EXPERIMENTAL which are up to date.

So now you have got only 434 dependencies left to look at. :-)
-- 
Stefan Richter
-=====-==--- -=== ==--=
http://arcgraph.de/sr/
