Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbZCRUcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbZCRUcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 16:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbZCRUbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 16:31:41 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:56200 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752604AbZCRUbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 16:31:39 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com
Subject: Microblaze linux support
Date: Wed, 18 Mar 2009 21:30:27 +0100
Message-Id: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I think that is the right time to send you next pack with 
Microblaze support. It is seventh pack - some previous packs
was review by community and I hope there are not any big faults.

We tested this kernel on some boards.
We have GIT server up and gitweb is available at http://developer.petalogix.com/git/gitweb.cgi

All information about git clone you can find on gitweb.
This pack is available in for-linus branch. Information about other branches are on gitweb too.

More information about microblaze fdt kernel you can find at www.monstr.eu/fdt/
If you want to test kernel with microblaze toolchain let me know.

I added only uart16550 and uartlite support - that's enought for first merge.


Thanks for you comments and especially for your ACK,
Michal



