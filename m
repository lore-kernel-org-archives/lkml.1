Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbZHSXoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbZHSXoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 19:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbZHSXon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 19:44:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34407 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896AbZHSXiU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 19:38:20 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "" <patrick@ostenberg.de>, "Rusty Russell" <rusty@rustcorp.com.au>
References: <xDf-7eSwYsC.A.-6B.klIjKB@chimera>
In-Reply-To: <xDf-7eSwYsC.A.-6B.klIjKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Era7U-todKF.A.5lD.3nIjKB@chimera>
Subject: [Bug #13341] Random Oops at boot at loading ip6tables rules
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 19 Aug 2009 22:40:40 +0200 (CEST)
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
Date		: 2009-05-19 09:08 (93 days old)
Handled-By	: Rusty Russell <rusty@rustcorp.com.au>


