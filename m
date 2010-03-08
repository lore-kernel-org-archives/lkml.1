Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab0CHDRG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 22:17:06 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54650 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab0CHDQ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 22:16:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=shrbqRnqkUe3W3V03ZrGepD/48fsCqeMfz0ydPC1ZARyEMRyS0khNLL9a0o3y4ketA
         6UZ+UaOqaeikcQzB/l0bkiqZD6HLfGIWc/jTMaNwdL/r3hiBZzO9sGcD1bcuH9ICFZ0x
         /2q/e5zkTerYLidzFFVORhJ8baEndfJ2eaPKU=
MIME-Version: 1.0
Date: Mon, 8 Mar 2010 11:16:57 +0800
Message-ID: <7b6bb4a51003071916v16f54d7fx9d3039826c1e1d80@mail.gmail.com>
Subject: where's include/linux/i2c-xiic.h?
From: Xiaotian Feng <xtfeng@gmail.com>
To: richard.rojfors@pelagicore.com, ben-linux@fluff.org,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

    I'm getting following compile error with current git tree, does
commit e1d5b6598cdc33257fe68302ae9db81d2f7bb883 miss file
include/linux/i2c-xiic.h?


    drivers/i2c/busses/i2c-xiic.c:39:28: error: linux/i2c-xiic.h: No
such file or directory
    drivers/i2c/busses/i2c-xiic.c: In function ‘xiic_i2c_probe’:
    drivers/i2c/busses/i2c-xiic.c:750: error: dereferencing pointer to
incomplete type
    drivers/i2c/busses/i2c-xiic.c:751: error: dereferencing pointer to
incomplete type
    make[2]: *** [drivers/i2c/busses/i2c-xiic.o] Error 1

Regards
Xiaotian
