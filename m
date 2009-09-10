Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbZIJKKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbZIJKKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755348AbZIJKKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:10:48 -0400
Received: from mail-yw0-f175.google.com ([209.85.211.175]:41300 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345AbZIJKKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:10:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=aDREfidf6UrR2byCObHzokBzWjUt9FmWhXzz9+Jm3JDw8E/i6mpmMaeR9QSsbqRHWg
         hBlBkgLhxU+XZlYS3BRDHh2NXTkTf2ZQIiGH5zhFHpc9Pg9E/Sl2YVx8jyJ7Vuh3vCOQ
         tY7r0i6cquuCgKbdQ7keTXWl4+lqJQx95TC9Y=
MIME-Version: 1.0
Date: Thu, 10 Sep 2009 15:40:51 +0530
Message-ID: <241b8f7b0909100310t267b82cq976929d2f7b7734@mail.gmail.com>
Subject: disable : Ctrl -C in the Kernel
From: Prabhu Chawandi <prabhu.chavandi@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

  I am running Some application at the end of rcS script file.

I need to disable Ctrl-c, i.e.  application should not kill after Ctrl-c.

and in some case I want Ctrl-C to work normally.

I am taking care in application about catching signal using signal(),
even then I think there is something from kernel side.

Can any one help ?????/

Thanks in advance
Prabhu
