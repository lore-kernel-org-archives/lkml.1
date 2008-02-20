Return-Path: <linux-kernel-owner+w=401wt.eu-S1760283AbYBTIkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760283AbYBTIkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 03:40:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbYBTIj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 03:39:58 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:33482 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbYBTIj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 03:39:57 -0500
Date: Wed, 20 Feb 2008 00:15:43 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 0/4] make dev_to_node return online node or -1
To: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802200015.43547.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please check update on dev_to_node().

YH
