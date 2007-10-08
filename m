Return-Path: <linux-kernel-owner+w=401wt.eu-S1757385AbXJHSxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbXJHSxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 14:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757176AbXJHSx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 14:53:27 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:52619 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353AbXJHSxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 14:53:25 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <470A7C91.3010503@s5r6.in-berlin.de>
Date: Mon, 08 Oct 2007 20:53:05 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: mgross@linux.intel.com
CC: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Subject: Re: RFC: reviewer's statement of oversight
References: <25555.1191864285@lwn.net> <20071008184029.GA31906@linux.intel.com>
In-Reply-To: <20071008184029.GA31906@linux.intel.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Gross wrote:
> On Mon, Oct 08, 2007 at 11:24:45AM -0600, Jonathan Corbet wrote:
>>  (a) I have carried out a technical review of this patch to evaluate its
>>      appropriateness and readiness for inclusion into the mainline kernel. 
[...]
>>  (c) While there may (or may not) be things which could be improved with
>>      this submission, I believe that it is, at this time, (1) a
>>      worthwhile addition to the kernel, and (2) free of serious known
>>      issues which would argue against its inclusion.
> 
> C-1 "worthwhile addition..." Probably shouldn't be part of this.  That's
> what additional Signed off by ACK's provide.  I think reviewed by should
> limit its scope to code correctness leaving the subjective "worthwhile"
> statements are better expressed with other tags.

A patch which is not "worthwhile" is also not "appropriate".  Mere
correctness in a mathematical sense is not enough as technical review
criterion.
-- 
Stefan Richter
-=====-=-=== =-=- -=---
http://arcgraph.de/sr/
