Return-Path: <linux-kernel-owner+w=401wt.eu-S932928AbXAWJfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928AbXAWJfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 04:35:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932927AbXAWJfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 04:35:24 -0500
Received: from ns2.gothnet.se ([82.193.160.251]:5091 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932932AbXAWJfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 04:35:23 -0500
From: thomas@tungstengraphics.com
To: linux-kernel@vger.kernel.org
Cc: arlied@gmail.com, arjan@infradead.org, davej@redhat.com, akpm@osdl.org
Subject: New patch: drm-populated memory types
Reply-To: thomas@tungstengraphics.com
Date: Tue, 23 Jan 2007 10:33:42 +0100
Message-Id: <1169544823318-git-send-email-thomas@tungstengraphics.com>
X-Mailer: git-send-email 1.4.1
In-Reply-To: <1168351618.3180.274.camel@laptopd505.fenrus.org>
References: <1168351618.3180.274.camel@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This one incorporates some of Arjan's suggestions and a fix for the 
i810 problem introduced with the previous patch.

/Thomas


