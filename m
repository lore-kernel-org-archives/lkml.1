Return-Path: <linux-kernel-owner+w=401wt.eu-S1761254AbZD2UHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761254AbZD2UHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 16:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbZD2UHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 16:07:43 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:42713 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbZD2UHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 16:07:43 -0400
MIME-Version: 1.0
In-Reply-To: <b56f065e0904291118r7f008508s32852ccd1bb0b645@mail.gmail.com>
References: <b2cdc9f30904182327w12a3ec32t90c7c6c34980577b@mail.gmail.com>
	 <20090427234947.394f774f@schatten>
	 <b2cdc9f30904272237h3a815282h7e6b932e1c252d17@mail.gmail.com>
	 <20090428095338.3e7b2062@hobbes>
	 <b2cdc9f30904290049k290a59bfh1265a66735b510e2@mail.gmail.com>
	 <20090429090607.2d351545@hobbes>
	 <b56f065e0904291118r7f008508s32852ccd1bb0b645@mail.gmail.com>
Date: Wed, 29 Apr 2009 21:07:42 +0100
X-Google-Sender-Auth: 79df09b4bf76963f
Message-ID: <b2cdc9f30904291307s622c4fe8sb4631e1f262d33bb@mail.gmail.com>
Subject: Re: 2.6.30-rc2 + xorg-intel-2.7.0 + DRM_I915_KMS = corruption
From: Alex Bennee <kernel-hacker@bennee.com>
To: Mateusz Kaduk <mateusz.kaduk@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, xorg@freedesktop.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/29 Mateusz Kaduk <mateusz.kaduk@gmail.com>:
> This is realy old issue now. Which I reported at begining of this month but
> exist much longer.
>
> https://bugs.freedesktop.org/show_bug.cgi?id=20896
>
> Two more people also experience this. This only happens with KMS mode.
> I am using 1.6.1 xorg/mesa master/ xf86-intel master and libdrm 2.4.9 kernel
> 2.6.30-rc3-git5.
>
> I hope someone can soleve this some day.

I don't think this is the same issue I'm seeing so I shall file another bug


-- 
Alex, homepage: http://www.bennee.com/~alex/
CV: http://www.bennee.com/~alex/cv.php
