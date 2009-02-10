Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbZBJUcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbZBJUcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 15:32:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755247AbZBJUbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 15:31:51 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:30194 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376AbZBJUbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 15:31:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jeqG4Yzaw1GcIFiB7dsh3wz1ilfcnhbxa5aX5+Znv4CZqWfspLR+VyMo2U8baRP0wg
         cDReJEz8rdaNS16LbxV6H5E1v1ljWwb5jd71ftb6Moce/AN7PXmDz3hjyVbBIUh3KKKh
         CuOVmLD4euCiWHUpVl+8VBbDq7oy80oAE4jFQ=
MIME-Version: 1.0
In-Reply-To: <cb7bb73a0902101229x21cb2e53g17f7e224dd92cd63@mail.gmail.com>
References: <1233967681-6378-1-git-send-email-giuseppe.bilotta@gmail.com>
	 <498D9F02.9000107@tremplin-utc.net> <498E46F2.1020401@gmail.com>
	 <4990BE23.8080301@tremplin-utc.net> <4990DEFD.4010700@gmail.com>
	 <49915832.1090501@tremplin-utc.net>
	 <cb7bb73a0902100307m4eab8ff2nfe9be8bed6a3b5b5@mail.gmail.com>
	 <49917650.1060208@tudelft.nl>
	 <cb7bb73a0902101229x21cb2e53g17f7e224dd92cd63@mail.gmail.com>
Date: Tue, 10 Feb 2009 21:31:49 +0100
Message-ID: <cb7bb73a0902101231t788dd820lb64a2a5e34761cf4@mail.gmail.com>
Subject: Re: [PATCH] lis3lv02d: add axes knowledge of HP Pavilion dv5 models
From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
To: =?ISO-8859-1?Q?=C9ric_Piel?= <E.A.B.Piel@tudelft.nl>
Cc: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>,
       Palatis Tseng <palatis@gmail.com>, Pavel Machek <pavel@suse.cz>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 9:29 PM, Giuseppe Bilotta
<giuseppe.bilotta@gmail.com> wrote:
> I reverted both my patch and the 'minimal init' patch from Pavel, then
> added this line. However, it seems to change nothing. Even using
> CTRL2_BLE instead of its negation doesn't seem to change much: same
> fluctuations, and cat'ing the sysfs file still gives 256, 512 etc.

Discard this, I'm an idiot and I'm not doing the testing properly. BRB.

-- 
Giuseppe "Oblomov" Bilotta
