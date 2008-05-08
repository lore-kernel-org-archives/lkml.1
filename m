Return-Path: <linux-kernel-owner+w=401wt.eu-S1763632AbYEHRbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763632AbYEHRbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 13:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754495AbYEHRbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 13:31:22 -0400
Received: from nn7.de ([85.214.94.156]:52104 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515AbYEHRbV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 13:31:21 -0400
Subject: 2.6.26-git: ata_piix link is slow to respond regression.
From: Soeren Sonnenburg <kernel@nn7.de>
To: linux-ide@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Date: Thu, 08 May 2008 19:30:42 +0200
Message-Id: <1210267842.4175.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

my macbook pro1,1 I suddenly hangs when booting current mainstream with:

ata_piix 0000:00:1f.2 MAP [P0 P2 -- -- ]
link is slow to respond, please be patient ﻿(ready=0)
SRST failed ﻿(errno=-1f)

these errors are repeated to hard resets follow but not use.

Soeren
