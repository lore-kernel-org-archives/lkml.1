Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbZCVKnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbZCVKnl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 06:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbZCVKnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 06:43:32 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:59527 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbZCVKnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 06:43:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=QO75q1tfAfQpENRSJjPVcyW1lUlllUwVkUuKk6q/QMMEbwVClIg8SBOURBgH14rFfk
         lx6kQ1JM/Ya2Z5IG1ZBaDSYCN+LBqbEpAlShi0bXp4nuiPPjPiRwWg4xMOnO5CbW6uQe
         q/z1W+01/2WKIRBx3/+OsGx86gQTASreh0O6c=
MIME-Version: 1.0
Date: Sun, 22 Mar 2009 11:43:28 +0100
Message-ID: <2d05c4580903220343l4b1359fx79f18b56203bd463@mail.gmail.com>
Subject: Test some kernel feature without recompile
From: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I know when you work on some kernel module, you can change code and load
module again and test it, but what if you change some built in kernel
.c file, why
would I need to recompile whole kernel just to see what happens if I change one
.c file ??

Why can I just compile one changed .c file and copy it where compiled version of
that file reside inside kernel tree? Or maybe there is some image info embedded
inside compiled files, so that file must belong to specific image from
which it is
installed ?

Thanks,

Dragoslav Zaric
