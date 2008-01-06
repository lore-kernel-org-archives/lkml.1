Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbYAFNYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbYAFNYT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 08:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbYAFNYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 08:24:10 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:47583 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbYAFNYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 08:24:08 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4780D644.8070005@s5r6.in-berlin.de>
Date: Sun, 06 Jan 2008 14:23:16 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>, Sam Ravnborg <sam@ravnborg.org>,
       Al Boldi <a1426z@gawab.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage	support
References: <20080105113024.209485f5.randy.dunlap@oracle.com> <20080105210330.GC22232@does.not.exist> <20080105210940.GA10302@uranus.ravnborg.org> <47801126.7020807@oracle.com> <20080105234540.GG22232@does.not.exist> <47802249.9010107@s5r6.in-berlin.de> <20080106005807.GH22232@does.not.exist> <4780BBAA.7020908@s5r6.in-berlin.de> <20080106115941.GB2082@does.not.exist> <4780CA63.50703@s5r6.in-berlin.de> <20080106125849.GE2082@does.not.exist>
In-Reply-To: <20080106125849.GE2082@does.not.exist>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sun, Jan 06, 2008 at 01:32:35PM +0100, Stefan Richter wrote:
>> No, the dependency relationships alone do not carry enough information.
>>   I am aware of that.
>>
>> For example, we certainly want [...]
> 
> I don't think your implementation would result in a better UI.

I'm afraid I am still very far from an implementation which we could
test.  And I will remain so for a while because I an inexperienced in
userspace UI design and programming and because there are lots and lots
of other more urgent tasks.  http://lwn.net/Articles/262741/
-- 
Stefan Richter
-=====-==--- ---= --==-
http://arcgraph.de/sr/
