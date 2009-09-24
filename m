Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884AbZIXJXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbZIXJXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 05:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZIXJXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 05:23:38 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:49071 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbZIXJXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 05:23:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=c0p2Ena9jnEp90ApEC298wenvvFKRl7+3g9z29AF2M7GseIQA38rWj/xuogsl7Hj71
         eFLqPKj3DOkU6r4EdQsOuikQ2SWUGaKP0XGQuz2Rbf9CSCGoWRFgznYMUyH+fxlkXwPP
         YGhhUGeXWawt94ayVZOOli8dQHg1WwTD/h9m4=
MIME-Version: 1.0
From: Pascal Terjan <pterjan@gmail.com>
Date: Thu, 24 Sep 2009 11:23:17 +0200
Message-ID: <e8ca35370909240223w6574a06dr8b32def058640aa6@mail.gmail.com>
Subject: go7007 does not build in linus HEAD
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  CC [M]  drivers/staging/go7007/s2250-board.o
drivers/staging/go7007/s2250-board.c:24:26: error: s2250-loader.h: No
such file or directory
