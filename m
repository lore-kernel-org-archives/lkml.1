Return-Path: <linux-kernel-owner+w=401wt.eu-S932930AbXG0H3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930AbXG0H3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 03:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758027AbXG0H3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 03:29:03 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:62599 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbXG0H3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 03:29:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=P+3BqyK447Q4fNpshDBjK3j5FTz66YQOqHWirT6fY6jTsCQXFeKflYX0z05/rIygkWM4p0CUatzQ7JJbitTJjmZR4VJIa6VgFKOJk8L0jexyppPIL0af0IdE2dE0p9yxfaKwKjLD/rJEHtVs2g2kenZvUYjZD0rM5zI4xwrEArs=
Message-ID: <4104961b0707270029r1deafa08ib7e4c60cb0161512@mail.gmail.com>
Date: Fri, 27 Jul 2007 15:29:00 +0800
From: "jidong xiao" <jidong.xiao@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: what does early parameter mean?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I saw there are some functions
do_early_param/parse_early_param,seems they are supporting for early
parameters,but what are early parameters?and how they are used?

Regards
Jason
