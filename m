Return-Path: <linux-kernel-owner+w=401wt.eu-S1757238AbYESHP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238AbYESHP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 03:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756758AbYESHPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 03:15:12 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:59911 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215AbYESHPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 03:15:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ku6yInQDN0N/cKSr4JE1xtZI5gimWRCCPcxXAjy7Y4BjC2z/bh3zfEllJUAep2U3Ut8j1j+7xQg3WgwybeAIo6hhkvYMA0k/OoxgVGkl8mq3B6xBpZtm/6OjDcybXx9or96UehkEu8SN4b0AC7/vqkezeks1LKr5hc7Ga/ozYPk=
Message-ID: <a8e1da0805190015t2044c33ar4b7320d0a37d7e09@mail.gmail.com>
Date: Mon, 19 May 2008 15:15:09 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "kernel list" <linux-kernel@vger.kernel.org>
Subject: [2.6.26-rc2-mm1] sync to speed up?
Cc: "Andrew Morton" <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With 2.6.26-rc2-mm1 I need to sync frequently. It's not normal as my
understanding.

1. scp a big file from a lan server. Firstly the speed is about 8M/s,
but the speed will slow down to 100K/s at last. After I exec "sync",
the speed will restore.

Is this a known issue?

Regards
dave
