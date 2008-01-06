Return-Path: <linux-kernel-owner+w=401wt.eu-S1757283AbYAFNiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbYAFNiw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 08:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbYAFNio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 08:38:44 -0500
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:34373
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbYAFNim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 08:38:42 -0500
Date: Sun, 6 Jan 2008 06:45:05 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Adrian Bunk <bunk@kernel.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Sam Ravnborg <sam@ravnborg.org>, Al Boldi <a1426z@gawab.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage	support
In-Reply-To: <4780D3E5.20908@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0801060643370.16883@asgard.lang.hm>
References: <200801051546.SAA08947@raad.intranet> <20080105113024.209485f5.randy.dunlap@oracle.com>
 <20080105210330.GC22232@does.not.exist> <20080105210940.GA10302@uranus.ravnborg.org>
 <47801126.7020807@oracle.com> <20080105234540.GG22232@does.not.exist>
 <47802249.9010107@s5r6.in-berlin.de> <20080106005807.GH22232@does.not.exist>
 <4780C728.1030806@s5r6.in-berlin.de> <20080106123728.GD2082@does.not.exist>
 <4780D3E5.20908@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jan 2008, Stefan Richter wrote:

> Adrian Bunk wrote:
>> On Sun, Jan 06, 2008 at 01:18:48PM +0100, Stefan Richter wrote:
>>> I'm afraid this can't be put into practice.  (User says which hardware
>>> and protocols he needs to be supported, scripts magically assemble a
>>> suitable configuration.)
>>
>> Distribution installers and live CDs like Knoppix even manage to
>> magically assemble a suitable configuration (e.g. autodetecting which
>> modules they should load) without asking the user any questions.
>
> Module autoloading is quite different.

but if boot scripts can figure out what modules to autoload, why can't 
scripts be written to figure out what drives to build into a system?

David Lang
