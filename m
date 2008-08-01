Return-Path: <linux-kernel-owner+w=401wt.eu-S1753779AbYHANuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbYHANuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 09:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755745AbYHANt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 09:49:57 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:46615 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709AbYHANt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 09:49:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=hrvFzBN4OTLn/v1d4LVCIdrRGbVsYOvjpWbd3NyMgkaw1S2LCEDY7ZTe+LMiYowRMN
         GseSWvVvA5VgDNaPO9PpcTI1mem5SqSKwitQdHu4FInoP3IZcTJVfZPUdixS57c0kK/0
         cjnrGot2XYdMg+0TT6oYRmONed1erL6lR6LhE=
Message-ID: <48f7fe350808010649l1111f48enbb6eca3cfcbba67f@mail.gmail.com>
Date: Fri, 1 Aug 2008 09:49:55 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: reiser4 for 2.6.27-rc1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why is reiser4 still not in a vanilla kernel for testing. I have had
to apply the reiser4 patches from -mm kernels to vanilla based
patchset for over a year now. Reiser4 works fine, what will it take to
get it included in vanilla? Here is a patch to add reiser4 to
2.6.27-rc1:

http://zen-sources.org/files/reiser4-for-2.6.27-rc1.patch

-Ryan
