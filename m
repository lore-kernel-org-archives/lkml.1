Return-Path: <linux-kernel-owner+w=401wt.eu-S936720AbXGSNBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936720AbXGSNBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763285AbXGSNAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:00:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:14098 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760000AbXGSNAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:00:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=V0cH+/yphHkyYiOrmBgddCuWsjNi3qMmfMjrmg0jDCU5Vml84qtLDTipbVQ/evl2YtlIg8NsSa0osLiZzifxFk6dJyuTfXFBahY6UG+IC6sW9IPmX8D8LQ9x4EZuHrAA5/fHaLujdxIH9XzvFcaa3Qaa8QcxXXWYLIAzjgCHiDc=
Message-ID: <3d0408630707190600r3c630db8h3dcc6550e93cfb27@mail.gmail.com>
Date: Thu, 19 Jul 2007 21:00:46 +0800
From: "Yan Zheng" <ukernel@gmail.com>
To: linux-ext4@vger.kernel.org
Subject: Why max_debt isn't used in ext4's find_group_orlov(...) ?
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

max_debt is used in ext2's find_group_orlov .  In ext4's
find_group_orlov, max_debt is only computed, but not used.  I wonder
whether it's a typo,  Can anyone give me a answer? The kernel source I
read is 2.6.22.

Thanks in advance.

----------------
Best Regards

YZ
