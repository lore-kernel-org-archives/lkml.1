Return-Path: <linux-kernel-owner+w=401wt.eu-S1760980AbXGEQy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760980AbXGEQy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 12:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758694AbXGEQyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 12:54:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:30484 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758393AbXGEQyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 12:54:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=q/FVf+TVhvZczxRN+h1jMqPT24/yijwV+Q6Hgw6QUEmqeW6JYo2feQG3PZjFAyOILAthaOsCPyNOZbf035VA3AD708OJ64rKNqY9so3CAURUrqp7jKSCRI+XPN5TXZpBbZrGGZ4hj9s8f2CK9dZvEx7G50yDa4v4yU/yWnN3OW4=
Date: Thu, 5 Jul 2007 20:54:08 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/4] Sky Cpu and Nexus: code cleanup and checkup
Message-ID: <20070705165408.GA7180@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patches clean up Sky Cpu and Nexus code and
fix potential NULL pointer usage.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
