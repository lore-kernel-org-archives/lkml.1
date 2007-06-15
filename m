Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbXFOO7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbXFOO7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 10:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbXFOO7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 10:59:30 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:2303 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758AbXFOO73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 10:59:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=THAgLZoGXw53eyMfmk9Eg0JY+YnCVSJ8h2R89AyS6vrzAJtY/mStvpEsFxQWj5iVXJtKf/1RgDR6l6Hf6+bmzFmA8ah/pkSSekA8BdGjIOxUiH4MZUUAbXtnTaKuBzOxmGaSW6dZP+fCYIaHf4oEuIrBjh/JBhTvuX/ZOqhJihI=
Message-ID: <4104961b0706150759l66fd713boac1a747637e73ee@mail.gmail.com>
Date: Fri, 15 Jun 2007 22:59:28 +0800
From: "jidong xiao" <jidong.xiao@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: How to printk unsigned long long variable?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For example,
typedef unsigned long long u64;
u64		*dma_mask;

Then how to use printk() to print out a dma_mask variable?

Regards
Jason Xiao
