Return-Path: <linux-kernel-owner+w=401wt.eu-S1752078AbZJKHxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbZJKHxX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 03:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbZJKHxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 03:53:22 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:47460 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbZJKHxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 03:53:17 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4AD18EB4.7010909@s5r6.in-berlin.de>
Date: Sun, 11 Oct 2009 09:52:20 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090926 SeaMonkey/1.1.17
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: James Morris <jmorris@namei.org>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       "Stephen D. Smalley" <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: mark a locally-only used function static
References: <tkrat.974f8a5e166a4c9f@s5r6.in-berlin.de> <20091011044221.GA8714@kroah.com>
In-Reply-To: <20091011044221.GA8714@kroah.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sun, Oct 11, 2009 at 03:02:46AM +0200, Stefan Richter wrote:
>> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> 
> Odd you didn't cc: the sysfs maintainer on this patch.  Any reason?
> 
> scripts/get_maintainer.pl is your friend...

Sheer laziness.  I trusted that those who introduced this function would
handle it for me.
-- 
Stefan Richter
-=====-==--= =-=- -=-==
http://arcgraph.de/sr/
