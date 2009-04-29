Return-Path: <linux-kernel-owner+w=401wt.eu-S1760876AbZD2V6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760876AbZD2V6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 17:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759073AbZD2V5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 17:57:50 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:37760 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322AbZD2V5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 17:57:48 -0400
MIME-Version: 1.0
In-Reply-To: <20090429090607.2d351545@hobbes>
References: <b2cdc9f30904182327w12a3ec32t90c7c6c34980577b@mail.gmail.com>
	 <20090427234947.394f774f@schatten>
	 <b2cdc9f30904272237h3a815282h7e6b932e1c252d17@mail.gmail.com>
	 <20090428095338.3e7b2062@hobbes>
	 <b2cdc9f30904290049k290a59bfh1265a66735b510e2@mail.gmail.com>
	 <20090429090607.2d351545@hobbes>
Date: Wed, 29 Apr 2009 22:57:46 +0100
X-Google-Sender-Auth: e573faa88a648165
Message-ID: <b2cdc9f30904291457m6a1da99v19548f465c43ef77@mail.gmail.com>
Subject: Re: 2.6.30-rc2 + xorg-intel-2.7.0 + DRM_I915_KMS = corruption
From: Alex Bennee <kernel-hacker@bennee.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Florian Mickler <florian@mickler.org>, xorg@freedesktop.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/29 Jesse Barnes <jbarnes@virtuousgeek.org>:
> This really sounds like one of the tiling related issues that should be
> fixed now, but if you're on the latest bits...
>
> Can you try setting the tiling option to false in your xorg.conf?
> Also, please file a bug for this at bugs.freedesktop.org with your X
> log & dmesg from your latest config; you can just assign it to me.

Less corruption, still crashes when X starts.

Bug raised: https://bugs.freedesktop.org/show_bug.cgi?id=21480

-- 
Alex, homepage: http://www.bennee.com/~alex/
CV: http://www.bennee.com/~alex/cv.php
