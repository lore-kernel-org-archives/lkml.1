Return-Path: <linux-kernel-owner+w=401wt.eu-S1757522AbYGTLCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbYGTLCn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 07:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756493AbYGTLCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 07:02:34 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:50276 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338AbYGTLCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 07:02:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=resent-from:resent-date:resent-message-id:resent-to:date:from:to:cc
         :subject:message-id:mime-version:content-type:content-disposition
         :user-agent;
        b=DmcHXtN4W5UolJ/EFnmUavBetvnwlVLlVHoLHHlFIWTeBAFUBkvS3GLRZfVyn14E8w
         KPTLkqJyzhTDxGBjjtn5U49lkuh2kc8MZYpXT/fB11x5sWSCxJNeA0dvgLKEF/qZpBnU
         qMYUi8OT1oGsnLyGClluKWsNH7nW1CpU7aHNM=
Date: Sun, 20 Jul 2008 14:58:22 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kenel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 0/2] Generic dma-coherent update
Message-ID: <20080720105822.GA4075@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These two patches probably are the last for the tip
core/generic-dma-coherent branch. The first one converts cris arch to
use the generic allocator. The second one adds documentation for new
interfaces. So, I think, the branch is ready to be scheduled for the
merge (or at least testing in the linux-next).

-- 
With best wishes
Dmitry

