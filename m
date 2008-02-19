Return-Path: <linux-kernel-owner+w=401wt.eu-S1762855AbYBSXQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762855AbYBSXQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 18:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758080AbYBSXQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 18:16:10 -0500
Received: from qmta07.westchester.pa.mail.comcast.net ([76.96.62.64]:32844
	"EHLO QMTA07.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758004AbYBSXQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 18:16:09 -0500
X-Authority-Analysis: v=1.0 c=1 a=rITDv7nW5hcA:10 a=Da8d6Nvqnv5vDHA1VjEA:9
 a=J0ssUM_SlkCwG1uVA_wA:7 a=zB1NShug9rK9y38vJig9qLmjCd8A:4 a=XF7b4UCPwd8A:10
To: linux-kernel@vger.kernel.org
From: Karl Dahlke <eklhad@comcast.net>
Reply-to: Karl Dahlke <eklhad@comcast.net>
Subject: adapter, what's in a name
Date: Tue, 19 Feb 2008 18:16:06 -0500
Message-ID: <20080119181606.eklhad@comcast.net>
Mime-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The longer I stay on this list, the more I will learn.
But it's high volume, so I may not be able to stay for long.

I completely understand your point about the word adapter.
It is highly overloaded, to the point that it is almost meaningless.
How about "accessibility"?
Drivers and modules designed to make linux more accessible
could be placed in drivers/accessibility in the source tree.
It's just a suggestion.
If there is a better word for this concept, please let me know.

And I finally understand what you are trying to say about /proc.
Processes, and perhaps memory and raid by extension,
but not everything under the planet.
Would it be better for accessibility drivers to create files through sysfs, e.g.
/sys/accessibility/jupiter/synth
Naturally the jupiter subtree would appear when that module was loaded,
and disappear when it was removed.

One person said, essentially,
"We'll worry about this when the first such driver comes along."
But that's a chicken egg problem, isn't it?
Let's set it up now, so things have a place to be.
Besides, speakup has been around for a long long time,
and jupiter almost as long.
These have both been converted to use the new notifiers,
along with pcclicks (sounds accompanying console output),
halfqwerty (one handed typing), and others.
Many of these will not need any virtual files, but some will,
and they need a place to be.
Beyond this, the software should exist somewhere, someday, in the source tree.
Not every driver under the sun, but some of them,
that have proved their merit, and meet the high standard of Linux coding, etc.
Mac comes bundled with an internal screen reader,
and windows has had an accessibility section for a long time, why not linux?
This is the best operating system in so many ways;
let's not be behind when it comes to accessibility.

Your thoughts are welcome.

Karl Dahlke
