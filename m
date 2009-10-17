Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343AbZJQSAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbZJQSAd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 14:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbZJQSAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 14:00:33 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:60605 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbZJQSAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 14:00:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=j9J41XUG1frcAF/3O1TmoGfIJYtcAxbwcEg3UHlLlnUrJb6ViBA7RFVhDMulomcMXt
         wIX+RJJydYgf+WUSrhwN/bbq6GblzvnL3lN2/eN8nB472u5EekH/hJDZT9cg1BkQtvoB
         /W3cVsjN6HJO82pvsmoCbxLIQKNbVo32TirAk=
MIME-Version: 1.0
Date: Sat, 17 Oct 2009 20:00:36 +0200
Message-ID: <2d05c4580910171100of7cb050o514892164cc88176@mail.gmail.com>
Subject: kdb
From: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have compiled kernel 2.6.31.4 and apply real-time patch
"patch-2.6.31.4-rt14.bz2"
Then I wanted to install "kdb", and I followed instructions from this site:

http://www.ibm.com/developerworks/linux/library/l-kdbug/

and I selected these patches:

kdb-v4.4-2.6.31-x86-4.bz2
kdb-v4.4-2.6.31-common-4.bz2

One patch was patched without problems [not sure which one :) ] and
other one had one
line with rejection [something about serial port]. Anyway, I compiled
kernel, and booted
into it after.

Questions:

1. When I press pause key everything freezes ? Is it because that one line of
rejection during patching ?

2. How do you invoke kdb ? When you invoke it properly, will "kdb"
shell will be visible in
terminal ?

regards
