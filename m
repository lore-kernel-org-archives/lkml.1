Return-Path: <linux-kernel-owner+w=401wt.eu-S1757466AbXENQ02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbXENQ02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 12:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757122AbXENQ0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 12:26:20 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:53273 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150AbXENQ0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 12:26:19 -0400
Message-ID: <46488D6A.3030608@s5r6.in-berlin.de>
Date: Mon, 14 May 2007 18:25:14 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
CC: mgarski@post.pl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Convert files to UTF-8 and some cleanups
References: <4647A52A.8000709@post.pl> <4647A868.4070201@post.pl> <46486EAE.3060009@s5r6.in-berlin.de> <alpine.DEB.0.98.0705141126550.19220@sigma.j-a-k-j.com>
In-Reply-To: <alpine.DEB.0.98.0705141126550.19220@sigma.j-a-k-j.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Anthony Kazos Jr. wrote:
> You can't post a patch to UTF-8 in plain text, because it isn't plain 
> text.

Of course it is, you said so...

> MTAs and MUAs mangle the hell out of them. Look back in the archives 
> for my postings. Once you've got something in UTF-8, -*THEN*- you can post 
> in plain inline text.

...yourself.  Just send as

	Content-type: text/plain; charset="utf-8"

Of course a patch like that will usually contain several character sets,
but that's no problem as long as the byte codes are preserved and we can
easily see how the end result looks like.  The important thing is that
the submitter's and committer's MUAs do it right and reviewers' MUAs do
it sort of right.  Also, nobody cares if there is still some pre-WWI
7bit-only MTA operated in some lone desert town.  And if some web
archive of LKML isn't compatible to internet mail, then that's tough luck.
-- 
Stefan Richter
-=====-=-=== -=-= -===-
http://arcgraph.de/sr/
