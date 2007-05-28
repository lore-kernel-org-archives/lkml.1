Return-Path: <linux-kernel-owner+w=401wt.eu-S1761710AbXE1Obi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761710AbXE1Obi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 10:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760900AbXE1ObU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 10:31:20 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:25689 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760744AbXE1ObT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 10:31:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=LGIudzq/NzNhqHYrZciuN3AM5FdQI1qJ96YLVG+/2dU+vVXHWs+oI3Z3bO1141rhuxgiZYvKamLasWK0mpCxaLnrIB7k4U/ryvCDj2YI7amObEloGTiJ3aHOlSh/EjxYFURin3gUYj23X4rIBVkJACIbwFFuRY/HFXDEvZZHWeE=
Date: Mon, 28 May 2007 18:30:15 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2] UDF: coding style conversion
Message-ID: <20070528143015.GA8766@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches converts current UDF coding style
to kernel coding style using Lindent and following
manual fixups.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Andrew, as I mentoined in my prev letters,
the patches are over current -mm tree
(including Jan's two patches and two
mine)

