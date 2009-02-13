Return-Path: <linux-kernel-owner+w=401wt.eu-S1753125AbZBMThZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbZBMThZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 14:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbZBMThJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 14:37:09 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:44752 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbZBMThH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 14:37:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=MN2gOIM3oqtmuXMZm0v8jVXRA8nygYsw+vpcls+Ar41I2qZRz/kKbYjEvX4N7h6ac4
         /zfgJFlXhILbAaydTGTwXyVtNoIINj1HJoG9qg8l/gABEI+CaTZEStzN5BacwUBvt7qo
         a1iAhbbh4tYkmgQW44m6zKdHKJ3t3kdZ/J1XE=
From: Diego Calleja <diegocg@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: "Can not ioremap virtual address" (was Re: [git pull] drm)
Date: Fri, 13 Feb 2009 20:38:18 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc4-00178-g071a0bc-dirty; KDE/4.2.0; x86_64; ; )
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
       dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Eric Anholt <eric@anholt.net>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Nico Schottelius <nico-linux-20090213@schottelius.org>
References: <alpine.DEB.2.00.0902090827390.32114@skynet.skynet.ie> <200902131828.22680.diegocg@gmail.com> <200902131104.04318.jbarnes@virtuousgeek.org>
In-Reply-To: <200902131104.04318.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902132038.18491.diegocg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Viernes 13 Febrero 2009 20:04:03 Jesse Barnes escribió:
> Does this prevent the message?  We map it WC in GEM but not in 
> i915_initialize...

Yes, the message has disappeared.
