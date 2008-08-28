Return-Path: <linux-kernel-owner+w=401wt.eu-S1752833AbYH1J7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbYH1J7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 05:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbYH1J73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 05:59:29 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:38065 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbYH1J71 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 05:59:27 -0400
Date: 28 Aug 2008 11:59:25 +0200
From: kovlensky@interia.pl
Subject: mounting windows shares with path exactly like on windows
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: TEXT/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-ORIGINATE-IP: 195.224.154.166
IMPORTANCE: Normal
X-MSMAIL-PRIORITY: Normal
X-PRIORITY: 3
X-Mailer: PSE3
Message-Id: <20080828095925.AB0ED313C53@f48.poczta.interia.pl>
X-EMID: fbb40acc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sorry to be slightly off topic, when it comes to this list, but I have no clue where to look for that and I think it can be doe on kernel level only.

In short - I've got bunch of applications running both on windows and linux and these applications exchange links to files mounted on both sides. The problem is that these paths are different, i.e. like D:/dir/file on windows and /mountpoint/dir/file on Linux. What I need is unifying them. So my idea is to have path translator on anything on kernel level, which will make Linux open call to D:/dir/file on Linux work and open /mountpoint/dir/file. Was anything close to that ever incorporated in kernel?

Applications are, as usual, closed source, and support for them, also as usual, answers "won't be fixed, switch to Windows, please". Very helpful.

Any other ideas of solving this problem are also warmly welcomed. Also on windows side.

----------------------------------------------------------------------
Nie szukam kochanka!
>> http://link.interia.pl/f1eeb

