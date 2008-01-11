Return-Path: <linux-kernel-owner+w=401wt.eu-S1762233AbYAKRbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762233AbYAKRbT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 12:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761692AbYAKRa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 12:30:57 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53006 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761579AbYAKRa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 12:30:56 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4787A787.2000503@s5r6.in-berlin.de>
Date: Fri, 11 Jan 2008 18:29:43 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
CC: Andy Whitcroft <apw@shadowen.org>, Bernd Petrovitsch <bernd@firmix.at>,
       linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] checkpatch.pl: show how to read from stdin
References: <20080111041120.085610726@mvista.com>	 <47872E35.3070705@gmail.com> <1200043035.29897.62.camel@imap.mvista.com>	 <47873505.7040008@gmail.com>  <1200043399.3905.9.camel@gimli.at.home>	 <1200043827.29897.70.camel@imap.mvista.com>  <47873833.30001@gmail.com>	 <1200044206.29897.73.camel@imap.mvista.com>	 <4787502B.2020606@s5r6.in-berlin.de> <47875809.7060301@gmail.com>	 <tkrat.b5ac0cacd128569b@s5r6.in-berlin.de> <1200071343.29897.86.camel@imap.mvista.com>
In-Reply-To: <1200071343.29897.86.camel@imap.mvista.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
> On Fri, 2008-01-11 at 18:06 +0100, Stefan Richter wrote:
>> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
>> +	print "When patchfile is -, read standard input.\n";

> Naww .. Why add documentation when you can just make it do the right
> thing ..

Why add code for a feature which already exists?
-- 
Stefan Richter
-=====-==--- ---= -=-==
http://arcgraph.de/sr/
