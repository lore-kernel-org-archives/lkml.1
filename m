Return-Path: <linux-kernel-owner+w=401wt.eu-S1757325AbXLWUOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbXLWUOg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 15:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbXLWUO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 15:14:26 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44220 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbXLWUOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 15:14:25 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <476EC18B.6080808@s5r6.in-berlin.de>
Date: Sun, 23 Dec 2007 21:14:03 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Dieter Ries <clip3@gmx.de>
CC: "Robert P. J. Day" <rpjday@crashcourse.ca>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Git Mailing List <git@vger.kernel.org>
Subject: Re: Updated Kernel Hacker's guide to git
References: <200612241807.kBOI746w008739@laptop13.inf.utfsm.cl> <476E42BF.1010300@garzik.org> <alpine.LFD.0.9999.0712230701520.14863@localhost.localdomain> <476E50DC.1040701@garzik.org> <alpine.LFD.0.9999.0712230715490.15596@localhost.localdomain> <476E5CFC.5070301@gmx.de>
In-Reply-To: <476E5CFC.5070301@gmx.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dieter Ries wrote:
> Robert P. J. Day schrieb:
>> when i got started with git, what i really wanted
>> was a list of what i (as a simple, non-developer user) could do once i
>> cloned a repository.
>>
>> to that end, i put together my own little reference list of git
>> commands.  for example, i collected ways to examine my repository --
>> git commands like branch, tag, log/shortlog, what-changed, show, grep,
>> blame, that sort of thing.  exactly the kind of stuff a new user might
>> want to know about, even without the ability to change anything.
> 
> Could you perhaps publish your reference list as kind of a christmas
> gift to all basic users like me?

Here are three out of four things which I do frequently with git repos:
I look at

  - commits and blobs in other people's trees with gitweb,

  - commits in a local tree with gitk,

  - specific changes to source code with qgit, using it as "git blame"
    GUI.

(The fourth thing is feeding a driver subsystem git tree at kernel.org
using a minimum number of git commands.  Everything else which I do with
git I do so infrequently that I have to reread manuals all the time.)
-- 
Stefan Richter
-=====-=-=== ==-- =-===
http://arcgraph.de/sr/
