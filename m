Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477AbZIRGqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbZIRGqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 02:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbZIRGqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 02:46:45 -0400
Received: from gir.skynet.ie ([193.1.99.77]:41913 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163AbZIRGqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 02:46:44 -0400
Date: Fri, 18 Sep 2009 07:46:50 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Jerome Glisse <jglisse@redhat.com>
cc: airlied@gmail.com, linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [PATCH] drm/radeon/kms: don't fail if we fail to init GPU
 acceleration
In-Reply-To: <1253107461-12750-1-git-send-email-jglisse@redhat.com>
Message-ID: <alpine.DEB.2.00.0909180746270.26562@skynet.skynet.ie>
References: <1253107461-12750-1-git-send-email-jglisse@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> kernel failed to initialize KMS. This should allow to give a
> working KMS setup in all case (even with non functionning accel).
> 
> Signed-off-by: Jerome Glisse <jglisse@redhat.com>

Applied thanks,

Dave.
