Return-Path: <linux-kernel-owner+w=401wt.eu-S1758774AbZBBXZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774AbZBBXZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 18:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbZBBXZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 18:25:24 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:16854 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbZBBXZX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 18:25:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=saWN1zUtyX/pofEv90rPo8QXXgIjWSa9wuawxvYFso/GNO94KBgSTJ6i3qXG90uusn
         XfN9MTq0qcIPQZOaVpcH38G918WTAVSU0oC+BhNEmh4u/nH7i6i4270pzTqWsLkw/JLP
         3hxiEPVn5BJq2u3IMjjHBUvOJEHXHE1v2GZlw=
MIME-Version: 1.0
Date: Mon, 2 Feb 2009 18:25:22 -0500
Message-ID: <a44ae5cd0902021525i28ba9e62jbb87624cc7f6b53d@mail.gmail.com>
Subject: =?windows-1252?B?Mi42LjI5LXJjMy1naXQzIC0tIGRyaXZlcnMvbWVkaWEvdmlkZW8vY3g4OC9jeDg4LWkyYw==?=
	=?windows-1252?B?LmM6MTIyOiBlcnJvcjogkXN0cnVjdCBjeDg4X2NvcmWSIGhhcyBubyBtZW1iZXIgbmFtZWQg?=
	=?windows-1252?B?kWdhdGVfY3RybJI=?=
From: Miles Lane <miles.lane@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf@foerster.gmx.de>,
       Gerd Knorr <kraxel@bytesex.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>, hverkuil@xs4all.nl,
       awalls@radix.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My apologies if I have CCed anyone who I should not have.  I did not
see a maintainer listed, so am trying the folks listed in the code as
well as the V4L folks who are responsible for what may be a related
driver (CX18).

Previously reported by Toralf Förster for 2.6.29-rc3 ("Subject: Fwd:
build issue #577 for v2.6.29-rc3"), 2009-01-29 13:08:09.

  CC [M]  drivers/media/video/cx88/cx88-i2c.o
drivers/media/video/cx88/cx88-i2c.c: In function 'cx88_call_i2c_clients':
drivers/media/video/cx88/cx88-i2c.c:122: error: 'struct cx88_core' has
no member named 'gate_ctrl'
drivers/media/video/cx88/cx88-i2c.c:123: error: 'struct cx88_core' has
no member named 'gate_ctrl'
drivers/media/video/cx88/cx88-i2c.c:127: error: 'struct cx88_core' has
no member named 'gate_ctrl'
drivers/media/video/cx88/cx88-i2c.c:128: error: 'struct cx88_core' has
no member named 'gate_ctrl'
make[4]: *** [drivers/media/video/cx88/cx88-i2c.o] Error 1
