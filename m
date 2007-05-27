Return-Path: <linux-kernel-owner+w=401wt.eu-S1753702AbXE0MaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbXE0MaL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 08:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbXE0M37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 08:29:59 -0400
Received: from [80.68.207.6] ([80.68.207.6]:51865 "EHLO smtp.unbit.it"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751303AbXE0M36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 08:29:58 -0400
Subject: [ANNOUNCE] UidBind LSM 0.4
From: Roberto De Ioris <roberto@unbit.it>
Reply-To: roberto@unbit.it
To: linux-security-module@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: UnBit
Date: Sun, 27 May 2007 14:30:04 +0200
Message-Id: <1180269004.14552.53.camel@hagrid>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

this is the new release of UidBind LSM:

http://projects.unbit.it/uidbind/


This new version adds a new configfs item, named 'comm'

If 'comm' is defined only the process with name == comm 
can call the bind() function 

(see the example on the website)

A patch for vanilla 2.6.21 is available on the website

-- 
Roberto De Ioris
http://unbit.it
JID: roberto@jabber.unbit.it

