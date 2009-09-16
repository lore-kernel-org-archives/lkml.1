Return-Path: <linux-kernel-owner+w=401wt.eu-S1758449AbZIPJfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758449AbZIPJfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 05:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbZIPJfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 05:35:53 -0400
Received: from mail-qy0-f172.google.com ([209.85.221.172]:41436 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbZIPJfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 05:35:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=I2TlJgdTyBJjKXupgLSZrfFjM0QIy/P65H/oVGABN35QtztsjPQfXoQax27vOAJO5D
         e7fZSdNN1RLfjenomwuk/ETHVB4/0YctuQmx7PjzBJ7eZT6C5HB5PUNgPGRcPv4wlKNW
         GJomtVx4Ht92gCyxTFdnRDueopy5kQ1hOSFmM=
MIME-Version: 1.0
Date: Wed, 16 Sep 2009 17:35:56 +0800
Message-ID: <2375c9f90909160235m1f052df0qb001f8243ed9291e@mail.gmail.com>
Subject: kcore patches (was Re: 2.6.32 -mm merge plans)
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 7:15 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>#kcore-fix-proc-kcores-statst_size.patch: is it right?
>kcore-fix-proc-kcores-statst_size.patch

Hmm, I think KAMEZAWA Hiroyuki's patchset is a much better fix for this.
Hiroyuki?

Thanks!
