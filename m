Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbYBXPhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbYBXPhd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 10:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbYBXPh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 10:37:26 -0500
Received: from el-out-1112.google.com ([209.85.162.180]:24768 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbYBXPhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 10:37:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mwp8Pq43syxBYrc4LSWqfh910mFZkRV57c2c66tILR6UhFbWZQa3t6O8GWS78SyWB+4Tptt63eF2iCNU+u+ZUSmQxg1hw0bxZYt+Lk3BeO41ux3sEd7iP7imfOfMQobBn61zpOIzR1h0bl3mg5qt9zGqGct6a+7vVY6VIfeZKVY=
Message-ID: <a4e6962a0802240737q5ac061dbva766514055dbb72c@mail.gmail.com>
Date: Sun, 24 Feb 2008 09:37:23 -0600
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] Make v9fs uname and remotename parsing more robust
Cc: "Markus Armbruster" <armbru@redhat.com>, linux-kernel@vger.kernel.org,
       "Latchesar Ionkov" <lucho@ionkov.net>,
       "Jim Meyering" <meyering@redhat.com>
In-Reply-To: <20080223000709.33a1c412.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <87skzu5cmd.fsf@pike.pond.sub.org>
	 <20080223000709.33a1c412.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 2:07 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
>  It would be better to present this as two patches.  One adds the new core
>  APIs and the other uses those APIs in v9fs.  The patches would take
>  separate routes into mainline.
>
>  I guess I can sneak this one in as-is, as long as the v9fs guys are OK with
>  that?
>

I'm fine with it.  Shall I pull it through the v9fs-devel patch line
or would you rather send it with your patches Andrew?

        -eric
