Return-Path: <linux-kernel-owner+w=401wt.eu-S1756692AbXEIJQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbXEIJQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 05:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756165AbXEIJPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 05:15:43 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:1336 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072AbXEIJPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 05:15:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=eVFi3ow7JUo0YTTsSiPBhKlIWXH8tOBeMdjCEOS/yXAKdKplfTCO0AqUAC1m4Hpg/eUsfZgIPy6cChFWmah6/mJdoEnEnn327uYaj/gbZtkMJqyIaT+2+bM8FbR/zgCweXgKjhzxWC3rIFfnzJOSFCYQ1kJcSEckgnQ0vZ0p2Xg=
Message-ID: <99e4df080705090215g33af7448x6171b1e314e6634d@mail.gmail.com>
Date: Wed, 9 May 2007 17:15:40 +0800
From: "la deng" <ladeng.mimi@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Why the 2.6.21 linux drop the "symbol IDEDMA_AUTO" in the menuconfig?
Cc: andre@linux-ide.org, torvalds@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Is't a regression in the IDE subsystem?
