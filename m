Return-Path: <linux-kernel-owner+w=401wt.eu-S1764983AbYCEHxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764983AbYCEHxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 02:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764712AbYCEHxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 02:53:38 -0500
Received: from webmail34.yandex.ru ([213.180.223.182]:41242 "EHLO
	webmail34.yandex.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764663AbYCEHxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 02:53:37 -0500
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Mar 2008 02:53:37 EST
X-Yandex-Spam: 0
From: Antipov Dmitry <dmantipov@yandex.ru>
To: linux-kernel@vger.kernel.org
Subject: Are Linux pipes slower than the FreeBSD ones ?
MIME-Version: 1.0
Message-Id: <1389671204703217@webmail34.yandex.ru>
Date: Wed, 05 Mar 2008 10:46:57 +0300
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

everyone knows that there are three kinds of lies: lies, damned lies, and benchmarks.
Despite of this obvious fact, recently I've tried to compare pipe performance on
Linux and FreeBSD systems. Unfortunately, Linux results are poor - ~2x slower than
FreeBSD. The detailed description of the test case, preparation, environment and
results are located at http://213.148.29.37/PipeBench, and everyone are pleased to
look at, reproduce, criticize, etc.

Thanks,
Dmitry
