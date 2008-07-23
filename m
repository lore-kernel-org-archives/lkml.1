Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbYGWHqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbYGWHqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 03:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbYGWHqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 03:46:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:63791 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbYGWHqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 03:46:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=AXW1BL0shuXO+Aztdx8XS9v7CKQ0uEQL3XzXC3wyuWVer8KVf1W956JEzIwIWUxbsp
         cJrJOZZcga3hylvfb1g2gOdCenQ2cXwERf9GPy2zW70iUBDRS6bACkYRtoDfmIzq8rUE
         pofnlBOCFL1YKyGnHYaWuQPAVofUFFASHxE4o=
Message-ID: <89239e000807230046s2ab36c2bi9b7f972701b63a77@mail.gmail.com>
Date: Wed, 23 Jul 2008 15:46:35 +0800
From: "Chen Zheng" <nkchenz@gmail.com>
To: kjwinchester@gmail.com
Subject: Re: Please add ZFS support (from GPL sources)
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <89239e000807230040l7491478fy2ed6a43f9f2fcdb7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <89239e000807230040l7491478fy2ed6a43f9f2fcdb7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 21, 7:39 am 2008, Kevin Winchester
>No one else seems to have volunteered, so I would certainly like to
>give it a try.  I guess I need to get the ZFS grub code, create a ZFS
>filesystem, and start looking around for information on linux
>filesystem development and ZFS (obviously without looking at any CDDL
>licensed code).

>Once I get a handle on that, I'll see where I can get before I need to
>ask a thousand questions.

Hi Kevin,  a few weeks ago I wrote a python module for fun,  which can read
most of zfs data structure. Based on ondiskformat0822.pdf, I started
it from scratch.

http://code.google.com/p/zfspy/

It maybe useful if you want to learn zfs on disk data structure.
