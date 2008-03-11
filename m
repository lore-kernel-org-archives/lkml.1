Return-Path: <linux-kernel-owner+w=401wt.eu-S1752420AbYCKXcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbYCKXcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 19:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbYCKXcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 19:32:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:42475 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbYCKXcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 19:32:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ULnFNkcid/jaOLydr5wPAWmmqR++rGvSVphHojG0r641PqYpA56VVLeOIPjzexrUwALRV9sAkNSSIC0NQRVbDD0OlLBqQY7VsHRAsAFkHkfThAGRwBXNhkuKRdWW3Zv20g9WD57rlowgkeGui/ovAH6z7Wcw10P1Z/l7Tn54rx4=
Message-ID: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com>
Date: Wed, 12 Mar 2008 00:32:14 +0100
From: "Fred ." <eldmannen@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Keys get stuck
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I (and many others) have a problem.

I am using Ubuntu 8.04 "Hardy Heron" (alpha).
xorg  1:7.3+10ubuntu6
Linux ubuntu 2.6.24-12-generic #1 SMP Mon Mar 10 15:32:00 UTC 2008
i686 GNU/Linux

MSI P35 Neo motherboard with a HP USB keyboard.

Sometimes the keys get "stuck" and it keeps on repeating the button
all the time.
It often happen when I play games, that it repeats one of the arrow keys.

Now this is a problem that lots of people have experienced.
I've experienced it with other kernels too.

https://bugs.launchpad.net/ubuntu/+source/xorg/+bug/194214

It is a very annoying bug, that happens to many users.
Restarting Xorg solves the problem.

Someone said this was a problem with dynticks, but I don't know.

Does anyone know what is causing this problem, and how to fix it?

As I don't subscribe to this list, I would like to get a reply sent to my email.
