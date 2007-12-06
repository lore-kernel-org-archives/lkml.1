Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbXLFSG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbXLFSG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 13:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbXLFSGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 13:06:51 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:49318 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbXLFSGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 13:06:51 -0500
From: Markus <M4rkusXXL@web.de>
To: linux-kernel@vger.kernel.org
Subject: programs vanish with 2.6.22+
Date: Thu, 6 Dec 2007 19:06:41 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200712061906.42070.M4rkusXXL@web.de>
X-Provags-ID: V01U2FsdGVkX1/IgQ1ZYhBOp03iSk7INHC4++kWx1iN7Nvi6ITi
	EGFIrrqjtf7ft6Pvx29I9DXzRmso+3Xd5IcBa/Fm9Ys8ySccgs
	0G4WDvyPk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Excuse my bad english, I am no native speaker. And please CC me, as I am 
not subscribed!

I am running an amd64 system with a stable gentoo. Today I upgraded to 
the kernel 2.6.22 and noticed many programs to disappear.
I use a kde desktop (3.5.7) and when amarok or kmail crash, normaly 
a "kde-crash-manager" pops up (but that happend very rarely), but not 
with 2.6.22+. It happens often and without any messagebox.
kdesktop, xchat, kicker, konqueror crashed as well.
It happens more often under heavy load. But it can also happen when 
idle. Also I have the feeling that it happens more often on 2.6.23+ I 
might be wrong.

I tried 2.6.23 and the current 2.6.24-rc4, which all show this problem 
aswell!
What has changed in 2.6.21 -> 2.6.22 that could cause such things?
Or who can tell that?
Can I help? How? (I use linux for years and can code, but I never 
debugged anything as big as the kernel...)


Markus

PS: Sorry thats so late, but I normaly stay on the distros stable kernel 
and only try vanilla when something is wrong ;)
