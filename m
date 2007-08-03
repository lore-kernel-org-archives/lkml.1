Return-Path: <linux-kernel-owner+w=401wt.eu-S1761808AbXHCLqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761808AbXHCLqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 07:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760533AbXHCLp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 07:45:56 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:42371 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899AbXHCLpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 07:45:55 -0400
To: jdike@addtoit.com
CC: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: UML: write errors on terminal
Message-Id: <E1IGvaz-0005Gq-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 03 Aug 2007 13:45:29 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I get errors in uml when writing to the xterm console.  For example if I do

$ cat bigfile
[some output]
  cat: write error: Operation not permitted

This is 2.6.23-rc1-mm2, I haven't yet checked other versions.

Miklos
