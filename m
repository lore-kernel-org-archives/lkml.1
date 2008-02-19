Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbYBSMrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbYBSMrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 07:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbYBSMrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 07:47:13 -0500
Received: from nn7.de ([85.214.94.156]:45019 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbYBSMrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 07:47:12 -0500
Subject: 2.6.25-rc2 regression - hang on suspend
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 19 Feb 2008 12:59:46 +0100
Message-Id: <1203422386.10992.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

since 2.6.25-rc1 (first version I tried) and still in rc2 (and git), I
see a hang on s2ram already when trying to suspend.

This is on a macbookpro 1,1  - which steps should I do next to help
isolating the problem?

Soeren
