Return-Path: <linux-kernel-owner+w=401wt.eu-S1753597AbYJQEza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbYJQEza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 00:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbYJQEzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 00:55:22 -0400
Received: from webmail87.yandex.ru ([77.88.47.161]:43114 "EHLO
	webmail87.yandex.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbYJQEzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 00:55:22 -0400
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Oct 2008 00:55:22 EDT
X-Yandex-Spam: 1
From: Antipov Dmitry <dmantipov@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: "Jordan Crouse" <jordan.crouse@amd.com>
Subject: Re: 2.6.27: 0 MHz CPU and wrong system time on AMD Geode system
MIME-Version: 1.0
Message-Id: <673951224218937@webmail87.yandex.ru>
Date: Fri, 17 Oct 2008 08:48:57 +0400
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jordan Crouse wrote:

> Could you try a 2.6.26 kernel? That will confirm that this is a new
> addition to 2.6.27.

Both 2.6.26 and 2.6.26.6 looks good (with CONFIG_GEODE_MFGPT_TIMER=y).

Dmitry
