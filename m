Return-Path: <linux-kernel-owner+w=401wt.eu-S1762279AbZE3W61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762279AbZE3W61 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 18:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755399AbZE3Wyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:54:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46803 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758136AbZE3Wyf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:54:35 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Author: Theodore Ts'o" <tytso@mit.edu>,
       "David Watson" <kernel-nospam@dbwatson.ukfsn.org>,
       "Jan Kara" <jack@suse.cz>
References: <THxQaUP0K2D.A.QkF.UVbIKB@chimera>
In-Reply-To: <THxQaUP0K2D.A.QkF.UVbIKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <PkPeJtNB3KO.A.hHG.lVbIKB@chimera>
Subject: [Bug #13232] ext3/4 with synchronous writes gets wedged by Postfix
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 May 2009 21:55:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.28 and 2.6.29.

The following bug entry is on the current list of known regressions
introduced between 2.6.28 and 2.6.29.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13232
Subject		: ext3/4 with synchronous writes gets wedged by Postfix
Submitter	: David Watson <kernel-nospam@dbwatson.ukfsn.org>
Date		: 2009-05-03 19:46 (28 days old)


