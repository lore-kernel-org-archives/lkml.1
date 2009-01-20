Return-Path: <linux-kernel-owner+w=401wt.eu-S1762955AbZATX2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762955AbZATX2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 18:28:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763046AbZATX2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 18:28:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:43431 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763015AbZATX23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 18:28:29 -0500
Subject: usr/include/linux/soundcard.h warnings for 'make headers_check'
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: alsa-devel@alsa-project.org, tiwai@suse.de,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 20 Jan 2009 21:08:22 +0530
Message-Id: <1232465902.3088.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usr/include/linux/soundcard.h is giving following warnings for 'make headers_check':
 usr/include/linux/soundcard.h:1047: extern's make no sense in userspace
 usr/include/linux/soundcard.h:1048: extern's make no sense in userspace
 usr/include/linux/soundcard.h:1049: extern's make no sense in userspace
 usr/include/linux/soundcard.h:1050: extern's make no sense in userspace
 usr/include/linux/soundcard.h:1051: extern's make no sense in userspace
 usr/include/linux/soundcard.h:1053: extern's make no sense in userspace
 usr/include/linux/soundcard.h:1055: extern's make no sense in userspace
 usr/include/linux/soundcard.h:1056: extern's make no sense in userspace
 usr/include/linux/soundcard.h:1061: extern's make no sense in userspace
 usr/include/linux/soundcard.h:1062: extern's make no sense in userspace
 usr/include/linux/soundcard.h:1078: extern's make no sense in userspace
 usr/include/linux/soundcard.h:1079: extern's make no sense in userspace

Do we need to fix these warnings.

If yes, then how can we fix these warnings.

Thanks

--
JSR

