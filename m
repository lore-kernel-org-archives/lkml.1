Return-Path: <linux-kernel-owner+w=401wt.eu-S1752161AbXLCQcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbXLCQcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 11:32:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbXLCQb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 11:31:56 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:46055 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbXLCQb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 11:31:56 -0500
Date: Mon, 3 Dec 2007 08:31:01 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Clemens Koller <clemens.koller@anagramm.de>
Cc: LKML List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation/BUG-HUNTING whitespace cleanup
Message-Id: <20071203083101.93141c4b.randy.dunlap@oracle.com>
In-Reply-To: <475405A9.4030608@anagramm.de>
References: <475405A9.4030608@anagramm.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Dec 2007 14:33:29 +0100 Clemens Koller wrote:

> Just a little whitespace cleanup patch for Documentation/BUG-HUNTING.
> 
> Signed-off-by: Clemens Koller <clemens.koller@anagramm.de>


Mostly looks OK, except for the last chunk:  why delete that line?
missing a + line?


@@ -130,7 +130,6 @@ You will then do:
             that makes the difference.
 
 Finally, you take all the info that you have, kernel revisions, bug
-description, the extent to which you have narrowed it down, and pass 
 that off to whomever you believe is the maintainer of that section.
 A post to linux.dev.kernel isn't such a bad idea if you've done some
 work to narrow it down.

---
~Randy
Features and documentation: http://lwn.net/Articles/260136/
