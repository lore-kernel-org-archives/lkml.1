Return-Path: <linux-kernel-owner+w=401wt.eu-S1757387AbZGKIR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbZGKIR3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 04:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbZGKIRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 04:17:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:35440 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbZGKIRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 04:17:16 -0400
Subject: [FIX REQUEST] Interrupt ID should be unsigned int
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 11 Jul 2009 13:47:03 +0530
Message-Id: <1247300223.2678.20.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

Like Processor ID, Interrupt ID is also inconsistent at some places used
as int and some places as unsigned int and unsigned.

Do you think there should be some consistency.

Thanks,
--
JSR


