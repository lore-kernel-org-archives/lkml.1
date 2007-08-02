Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbXHBMit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbXHBMit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 08:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbXHBMiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 08:38:13 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:16925 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893AbXHBMiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 08:38:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=rJ9VZU4IFrsYiFMZegt2bL4q/pWyfJVjNV3ETXeqF/3ypu69YV+HSTP2kGeoFUZH5ClWqzW30mCLaffPbdopmmnL3y/Ufblmi21DLepvDCiFhVTjN4uz6iFXg/9XKroOJYqzNgrl5mSmLX7dRHbxgdwDjHiwRDg6QPxTk302PoA=
Subject: [PATCHSET 2.6.23-rc1] sysfs: locking fix and cleanups, take #2
In-Reply-To: 
X-Mailer: git-send-email
Date: Thu, 2 Aug 2007 21:38:02 +0900
Message-Id: <11860582821512-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

This is the second take of sysfs-cleanup patchset.  Changes from the
last take[L] are...

* wrong patch description updated
* comment updated
* first two patches were accepted into -gregkh and dropped from this
  series.

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel/563067


