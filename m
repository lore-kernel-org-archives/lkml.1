Return-Path: <linux-kernel-owner+w=401wt.eu-S1752537AbXJUBxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbXJUBxL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 21:53:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbXJUBw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 21:52:28 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:56843 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbXJUBw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 21:52:27 -0400
Date: Sun, 21 Oct 2007 01:51:50 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: James Morris <jmorris@namei.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 0/4] MultiAdmin 1.0.7
Message-ID: <Pine.LNX.4.64.0710210149270.1997@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


As per James's request, I am reposting the MultiAdmin LSM in its 
current form (2.6.23.1, still with the modular LSM interface). 
