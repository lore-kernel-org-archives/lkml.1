Return-Path: <linux-kernel-owner+w=401wt.eu-S933902AbYBHS7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933902AbYBHS7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760599AbYBHS7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 13:59:35 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:37475 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760326AbYBHS7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:59:33 -0500
Message-ID: <47ACA693.9010407@s5r6.in-berlin.de>
Date: Fri, 08 Feb 2008 19:59:31 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: ael <law_ence.dev@ntlworld.com>
CC: linux-kernel@vger.kernel.org, andi@firstfloor.org, jikos@jikos.cz
Subject: Re: git tree urls
References: <foheti$vgb$1@ger.gmane.org>
In-Reply-To: <foheti$vgb$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ael wrote:
> I have trouble locating some of the git urls (the mm repository, for
> example).

Have a look at Andrew's announcements of -mm when he releases one.

[...]
> I would guess that the main development repository is
> pub/scm/linux/kernel/git/torvalds/linux-2.6.git/
> but that is speculation.
> 
> Can someone who knows take a minute or two to put a note of the main
> urls on www.kernel.org
[...]

At www.kernel.org, click on "C" = "current changesets" of the 2.6 kernel
series to get to the gitweb interface of Linus' tree.  There you find
the URL to feed to "git clone" if you want to track Linus' tree.
-- 
Stefan Richter
-=====-==--- --=- -=---
http://arcgraph.de/sr/
