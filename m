Return-Path: <linux-kernel-owner+w=401wt.eu-S1758815AbZIFVOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815AbZIFVOm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 17:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758806AbZIFVOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 17:14:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49058 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758720AbZIFVOh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 17:14:37 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "" <patrick@ostenberg.de>, "Rusty Russell" <rusty@rustcorp.com.au>
References: <aIL9jMAYJnG.A.WjH.M3BpKB@chimera>
In-Reply-To: <aIL9jMAYJnG.A.WjH.M3BpKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <hKF51Pczj6N.A.p7.f5BpKB@chimera>
Subject: [Bug #13341] Random Oops at boot at loading ip6tables rules
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  6 Sep 2009 20:11:48 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13341
Subject		: Random Oops at boot at loading ip6tables rules
Submitter	:  <patrick@ostenberg.de>
Date		: 2009-05-19 09:08 (111 days old)
Handled-By	: Rusty Russell <rusty@rustcorp.com.au>


