Return-Path: <linux-kernel-owner+w=401wt.eu-S934232AbZGQIWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934232AbZGQIWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 04:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934219AbZGQIWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 04:22:47 -0400
Received: from mx13.lb01.inode.at ([62.99.145.15]:53347 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934196AbZGQIWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 04:22:46 -0400
X-Greylist: delayed 147023 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Jul 2009 04:22:46 EDT
Message-ID: <62.47.75.132.1247818962.wm@webmail.inode.at>
Date: Fri, 17 Jul 2009 10:22:42 +0200 (CEST)
Subject: RE: mounting cifs filesystems not possible
From: "Gerhard Hintermayer" <g.hintermayer@inode.at>
To: <linux-kernel@vger.kernel.org>
X-Priority: 3
Importance: Normal
Reply-To: g.hintermayer@inode.at
X-Mailer: SquirrelMail (version 1.2.8)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I discovered that this is a slow_path issue, which is tainting the kernel,
I already filed this as a gentoo bug, but since this is kernel related, I
think here's the right place.  The server I'm trying to mount is a Windows
2003 Server, I  can inquire more if neccessary.
PS: please CC me, I not on the list anymore (too much traffic, just how I
was warned)

Gerhard



