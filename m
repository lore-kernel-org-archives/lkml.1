Return-Path: <linux-kernel-owner+w=401wt.eu-S1761180AbYBFHfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761180AbYBFHfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 02:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759678AbYBFHf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 02:35:29 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:63434 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbYBFHf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 02:35:28 -0500
Message-Id: <200802060735.m167ZPGx017472@dell2.home>
To: linux-kernel@vger.kernel.org
Subject: tool to keep multiple architectures/kernel configs straight?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <17469.1202283325.1@dell2.home>
Date: Wed, 06 Feb 2008 02:35:25 -0500
From: "Marty Leisner" <leisner@rochester.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Supporting a number of kernels/platforms there are:
     1) common options (which should be all the same across all platforms)
     2) platform/processor specific options
     3) some options are common across kernel versions but not across
        all versions

Is there a good way to maintain this (beyond eyeballing the
.config files?)

marty
