Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769Ab0BHApz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 19:45:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55546 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757669Ab0BHApv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 19:45:51 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Rich Ercolani" <rercola@acm.jhu.edu>
References: <2uzMDuY-7_O.A.M1G.7X1bLB@chimera>
In-Reply-To: <2uzMDuY-7_O.A.M1G.7X1bLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <iuJeop2ribM.A.fPB.YZ1bLB@chimera>
Subject: [Bug #14868] flood of "don't try to register things with the same name in the same directory." on upgrade to 2.6.32
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon,  8 Feb 2010 01:28:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14868
Subject		: flood of "don't try to register things with the same name in the same directory." on upgrade to 2.6.32
Submitter	: Rich Ercolani <rercola@acm.jhu.edu>
Date		: 2009-12-24 02:44 (46 days old)


