Return-Path: <linux-kernel-owner+w=401wt.eu-S1762452AbYDSWvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762452AbYDSWvw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 18:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbYDSWvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 18:51:43 -0400
Received: from ns.netcenter.hu ([195.228.254.57]:50185 "EHLO netcenter.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421AbYDSWvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 18:51:43 -0400
X-Greylist: delayed 2158 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Apr 2008 18:51:42 EDT
Message-ID: <09eb01c8a26a$dbf5eee0$0404a8c0@dcccs>
From: "Janos Haar" <djani22@netcenter.hu>
To: <linux-kernel@vger.kernel.org>
Subject: Sparse file question for data recovery
Date: Sun, 20 Apr 2008 00:15:15 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1914
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1914
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

It is a way to use sparse files (or sg. else) to try to recover some big
block device when it is readonly?

I mean the original device is marked readonly, and only the changes are
saved for the sparse file.
This is useful if i want to only try to repair corrupted (or miss-assembled)
raid arrays, image from damaged hdd, etc...

Like only save the "undo" information independently from the repairing
program.

I only know that with nbd-server, but i wish to use a simple local solution.

Somebody have an idea? :-)

Thanks,

Janos Haar

