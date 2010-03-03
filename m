Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab0CCUqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 15:46:09 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:63549 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756640Ab0CCUp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 15:45:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=u5P3ERgT9S/WV7tXP4p9krfvzNAydiHUL42DjwoPGQ4kXK9/lpuBWm8uQi/1A3Mh1S
         0QzbNpkVl1PX1366yqHA9SnucaP4F7mjmYZpyBFaEm0DaXtS15xe22ZvKkgNGOL31kDq
         pww6wRaGg4V0o/DnVB2w7OVPxpRQaGif9PRgs=
MIME-Version: 1.0
Date: Wed, 3 Mar 2010 21:45:53 +0100
Message-ID: <40a4ed591003031245g79cca873t89e90545337a9067@mail.gmail.com>
Subject: evdev keyboard driver stopped working after upgrading from Kernel 
	2.6.33-rc8 to 2.6.33 (official release)
From: Zeno Davatz <zdavatz@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I am always updating to the latest rc Kernel Release, that Linus shares via Git.

I also upgraded to the latest stable kernel version after rc-8, to
2.6.33. But since I am on 2.6.33 my Xorg evdev-Driver stopped working.
I can hit any key on the keyboard, but nothing will happen. The mouse
and the graphics are just fine and work well.

I have an Asus Eeepc 1101HA, with Gentoo and the psb-kmod driver compiled.

Xorg starts just fine, does not crash but the keyboard does not react.

Everything worked fine on 2.6.33-rc8.

Any hints what changed from 2.6.33-rc8 to 2.6.33 stable that made my
keyboard stop reacting?

Let me know and I will test.

Best
Zeno
