Return-Path: <linux-kernel-owner+w=401wt.eu-S1757581AbYAFMm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbYAFMm4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 07:42:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbYAFMms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 07:42:48 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:45622 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbYAFMmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 07:42:47 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4780CC6D.1090906@s5r6.in-berlin.de>
Date: Sun, 06 Jan 2008 13:41:17 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>, Sam Ravnborg <sam@ravnborg.org>,
       Al Boldi <a1426z@gawab.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage	support
References: <200801051546.SAA08947@raad.intranet> <20080105113024.209485f5.randy.dunlap@oracle.com> <20080105210330.GC22232@does.not.exist> <20080105210940.GA10302@uranus.ravnborg.org> <47801126.7020807@oracle.com> <4780C15C.2000904@s5r6.in-berlin.de> <20080106120527.GC2082@does.not.exist>
In-Reply-To: <20080106120527.GC2082@does.not.exist>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sun, Jan 06, 2008 at 12:54:04PM +0100, Stefan Richter wrote:
>> The user who wants to enable usb-storage /has/ to go into the SCSI menu
>> anyway to answer whether he needs sd, sr, st, sg, command logging...
> 
> That's a different UI problem that has to be fixed.
> 
> The "SCSI support type" menu has to move out of the SCSI menu.

That's right, maybe create a "SCSI related I/O protocols" menu or
something like that.  I seem to remember previous attempts to do this. :-)
-- 
Stefan Richter
-=====-==--- ---= --==-
http://arcgraph.de/sr/
