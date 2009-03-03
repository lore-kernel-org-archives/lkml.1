Return-Path: <linux-kernel-owner+w=401wt.eu-S1758370AbZCCP5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370AbZCCP5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 10:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754768AbZCCP4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 10:56:50 -0500
Received: from igw2.watson.ibm.com ([129.34.20.6]:50169 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbZCCP4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 10:56:49 -0500
From: Dan Smith <danms@us.ibm.com>
To: containers@lists.osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] c/r: Add s390 support
Date: Tue,  3 Mar 2009 10:56:01 -0500
Message-Id: <1236095764-19325-1-git-send-email-danms@us.ibm.com>
X-Mailer: git-send-email 1.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set adds checkpoint/restart support for s390.  It is to be applied on
top of Oren's ckpt-v13 set[1] and has been tested with the single and multi-
process tests in user-cr.

1: http://lkml.org/lkml/2009/1/27/227

