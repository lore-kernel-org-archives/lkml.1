Return-Path: <linux-kernel-owner+w=401wt.eu-S1751792AbXHSFUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbXHSFUp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 01:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750738AbXHSFUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 01:20:36 -0400
Received: from web52504.mail.re2.yahoo.com ([206.190.48.187]:39184 "HELO
	web52504.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750711AbXHSFUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 01:20:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=hJTrsXcUj/H4QvDzyA5Qt1ARLuaAdrkTJs6TK4Y6L33vuVU5cMuPPjP+c2CMHBFtDLkAe9Q73ZXqDe7Xraz3brGejPGClRCuqz6m1Gje3SMrtXoTYUZjnhiuCf7wlTJebC3D6ooFLLakjrlrXYPjuSKMLVkbvcqy2alvnwDJdnA=;
X-YMail-OSG: ZHTWY3wVM1mOSQy2AdUVTtQuzGm39GdGKBo.yLhtHahmNa0AdBCgEZQEQeHQ8b9H9RKIH9P6wXjZO4slZKBtn.Hc53LxYiZZal2T_hfP6gymdGcGLIJ3wRFjDjOD6w--
Date: Sat, 18 Aug 2007 22:20:34 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: The vi editor causes brain damage
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <964583.28477.qm@web52504.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Let me give you and example of the difference between
Linux open source world brain damaged thinking and
what it's like out here in the real world.

Go to a directory with 10k files and type:

rm *

What do you get?

/bin/rm: Argument list too long

If you map a network drive in DOS and type:

del *

It works.

That's the problem with the type of thinking in the
open source world. Why can DOS delete an infinite
number of files and rm can't? Because rm was written
using the "vi" editor and it causes brain damage and
that's why after 20 years rm hasn't caught up with
del.

Before everyone gets pissed off and freaks out why
don't you ponder the question why rm won't delete all
the files in the directory. If you can't grasp that
then you're brain damaged.

Think big people. Say NO to vi!


Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


       
____________________________________________________________________________________
Yahoo! oneSearch: Finally, mobile search 
that gives answers, not web links. 
http://mobile.yahoo.com/mobileweb/onesearch?refer=1ONXIC
