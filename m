Return-Path: <linux-kernel-owner+w=401wt.eu-S1758783AbXHKGgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783AbXHKGgL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 02:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758876AbXHKGcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 02:32:51 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58735 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758837AbXHKGcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 02:32:47 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46BD57AA.4050405@s5r6.in-berlin.de>
Date: Sat, 11 Aug 2007 08:31:06 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <andi@firstfloor.org>,
       =?ISO-8859-1?Q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Documentation files in html format?
References: <20070809113122.3aa508e4@oldman.hamilton.local> <200708091508.20626.hjk@linutronix.de> <p73hcn8g25m.fsf@bingen.suse.de> <20070810074047.GC31307@uranus.ravnborg.org> <46BC6DA9.1050903@s5r6.in-berlin.de> <20070810201235.GA4133@uranus.ravnborg.org> <46BCF458.7010300@gmail.com>
In-Reply-To: <46BCF458.7010300@gmail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> On 08/10/2007 10:12 PM, Sam Ravnborg wrote:
> 
>>> What primary requirements does in-tree Linux kernel documentation have
>>> to fulfill in general?
>>
>> Skipping the obvious ones such as correct, up-to-date etc.
>> o Readable as-is
>> o Grepable
>> o buildable as structured documents or almost like a single book
>> o Easy to replicate structure
>> o Maintainable in any decent text-editor (emacs, vim, whatever)

Low entry barrier for patches from unsuspecting occasional contributors?

> Easy to put online?

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=tree;f=Documentation
http://lxr.linux.no/source/Documentation/
http://users.sosdg.org/~qiyong/lxr/source/Documentation/
http://www.linux-m32r.org/lxr/http/source/Documentation/
http://lxr.free-electrons.com/source/Documentation/


(I admit though that formats like asciidoc or docbook are beneficial for
larger documentation files which want chapters, table of contents, and
internal crossreferences.)
-- 
Stefan Richter
-=====-=-=== =--- -=-==
http://arcgraph.de/sr/
