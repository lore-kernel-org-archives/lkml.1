Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbYKDOcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbYKDOcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 09:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbYKDOc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 09:32:28 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:33389 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbYKDOc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 09:32:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=ByDE3ykwD2VjiSa2u1viq+qnVoj7hV3CCxxYkCAFkRjJqb6OeGIUNa+6RHtc7Xm711
         vISeqnVc70brkG4XLlsR+vxbFn70c+X20BnTm1paSDpI2uVPy117ReqxTUTms/E63F2z
         S9YN9oLNBq3KJzYNTn3f5aKRU2QlpuLi5CxYg=
Message-ID: <6278d2220811040632u7a36d68ekad5de517fd0671bb@mail.gmail.com>
Date: Tue, 4 Nov 2008 14:32:25 +0000
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Linux Netdev" <netdev@vger.kernel.org>,
       "Linux Networking" <linux-net@vger.kernel.org>
Subject: time for TCP ECN defaulting to on?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is it time to enable TCP ECN per default and get the benefits, since
router support has been around and known-about for really considerable
time?

Perhaps it should be a question of enabling it, and educating people
to disable it if they run into issues, since we'll probably be in the
same situation in 5 years...and it'll be some time before these
kernels hit devices/servers anyway.

Daniel
-- 
Daniel J Blueman
