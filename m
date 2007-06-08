Return-Path: <linux-kernel-owner+w=401wt.eu-S969554AbXFHQmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969554AbXFHQmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968223AbXFHQmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:42:08 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:25165 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1764796AbXFHQmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:42:07 -0400
Date: Fri, 08 Jun 2007 10:45:06 -0600
From: dougthompson@xmission.com
To: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH 0/6] driver edac code tidying fixes-2nd submission with
 subject line
Message-ID: <46698792.FzImy2rNsJmiGMBb%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Douglas Thompson <dougthompson@xmission.com>

This set of 6 patches for EDAC fix some code style issues,
typos, support for archs other than X86, new pci_ids.h
devices entries for the K8 Northbridge and fix for compile
warnings.

These patches are against 2.6.22-rc4-mm2

