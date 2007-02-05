Return-Path: <linux-kernel-owner+w=401wt.eu-S1752620AbXBEArn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbXBEArn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 19:47:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbXBEArm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 19:47:42 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:49757 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623AbXBEArm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 19:47:42 -0500
Message-id: <239243476136477586@wsc.cz>
References: <2106930977152662464@wsc.cz>
	<58cb370e0702030731i61b32e93j3f7a8f0e061cb136@mail.gmail.com>
	<4af2d03a0702030739n77afadf4t8d26d66416b075e1@mail.gmail.com>
	<20070203155044.GA32134@suse.de> <45C5BDED.3090707@gmail.com>
	<20070204172921.GA11128@suse.de>
	<58cb370e0702041631p1b8b31c4y1dd6a92adfdd2c1@mail.gmail.com>
In-Reply-To: <58cb370e0702041631p1b8b31c4y1dd6a92adfdd2c1@mail.gmail.com>
Subject: [PATCH 1/1] MAINTAINERS, remove two dead e-mail
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Greg KH <gregkh@suse.de>
Date: Mon,  5 Feb 2007 01:47:41 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz napsal(a):
> On 2/4/07, Greg KH <gregkh@suse.de> wrote:
>> On Sun, Feb 04, 2007 at 12:05:17PM +0100, Jiri Slaby wrote:
>> > Please, are you experiencing this too? Maybe it's about to be 
>> removed from
>> > MAINTAINERS?
>> > Diagnostic-Code: X-Postfix; host mail.cyclades.com[64.186.161.6] 
>> said: 550
>> >    <async@cyclades.com>: Recipient address rejected: undeliverable 
>> address:
>> >    host usmail.cyclades.com[64.186.161.37] said: 550 
>> async@cyclades.com...
>> >    No
>> >    such user (in reply to RCPT TO command) (in reply to RCPT TO 
>> command)
>>
>> Yes, I got it too.
> 
> me too
> 
> Jiri, while at it maybe you could also try to verify the situation with
> the other @cyclades.com email address from the MAINTAINERS file
> (pc300@cyclades.com for pc300 driver)?

Not even this one exists
550 pc300@cyclades.com... No such user

--

MAINTAINERS, remove two dead e-mail

Cyclades no longer serves the 2 e-mails listed in MAINTAINERS.
Remove them and mark those entries as Orphaned.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 9409f7e4a66eeb82b494d1f7371808dffa51bbe0
tree e3f505b099ee60ecfade367a39a602cbd6db5085
parent e04ecea3d2a26acd32e48da422f233973a5c0dd4
author Jiri Slaby <jirislaby@gmail.com> Mon, 05 Feb 2007 01:43:25 +0100
committer Jiri Slaby <jirislaby@gmail.com> Mon, 05 Feb 2007 01:43:25 +0100

 MAINTAINERS |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index be02ad7..da74a33 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -996,14 +996,12 @@ L:	cycsyn-devel@bazar.conectiva.com.br
 S:	Maintained
 
 CYCLADES ASYNC MUX DRIVER
-M:	async@cyclades.com
 W:	http://www.cyclades.com/
-S:	Supported
+S:	Orphan
 
 CYCLADES PC300 DRIVER
-M:	pc300@cyclades.com
 W:	http://www.cyclades.com/
-S:	Supported
+S:	Orphan
 
 DAMA SLAVE for AX.25
 P:	Joerg Reuter
