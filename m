Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbXJHXmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbXJHXmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 19:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbXJHXmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 19:42:14 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34332 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbXJHXmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 19:42:13 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <470AC050.6010402@s5r6.in-berlin.de>
Date: Tue, 09 Oct 2007 01:42:08 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: RFC: reviewer's statement of oversight
References: <10940.1191883390@lwn.net>
In-Reply-To: <10940.1191883390@lwn.net>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet wrote:
> All of these
> +tags have the form:
> +
> +	Something-done-by: Full name <email@address>

To be precise:
    Something-done-by: Full name <email@address> [optional random stuff]

"Some people also put extra tags at the end.  They'll just be ignored
for now, but you can do this to mark internal company procedures or just
point out some special detail about the sign-off.", says
SubmittingPatches.  I actually do so on occasions.
-- 
Stefan Richter
-=====-=-=== =-=- -=--=
http://arcgraph.de/sr/
