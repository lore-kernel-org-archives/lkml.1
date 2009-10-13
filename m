Return-Path: <linux-kernel-owner+w=401wt.eu-S932933AbZJMFqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933AbZJMFqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 01:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756911AbZJMFqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 01:46:55 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:50776 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645AbZJMFqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 01:46:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=rYoErvpbTa0ea4LsHTSNpKpZC4fWRJNzfrXIxLdubvGjeknInxYrVBYt7UvCUb/RNQ
         MPrq9Rb38wP0Z8/h24tl0R73QXBsPpOI4oLOktBSyta7w3H+W+AXEcET9X5+U7SWD3nb
         QPRrdFRZYQA2H8XAtKCewtioeFn8AIDLjaGu8=
MIME-Version: 1.0
Date: Tue, 13 Oct 2009 13:46:18 +0800
Message-ID: <363172900910122246y2ea4ee69gf133e725b0a54146@mail.gmail.com>
Subject: Drivers compiled into the kernel can reduce code size
From: =?GB2312?B?t8nR1Q==?= <win847@gmail.com>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Greg Ungerer <gerg@snapgear.com>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

       I has a question below:

     Why Drivers compiled into the kernel can reduce code size
compared with Module ways?

     Kernel + Driver Module (Code Size) > Kernel(include Driver)


    Thanks!
