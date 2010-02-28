Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031985Ab0B1UIk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 15:08:40 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:34077 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031964Ab0B1UIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 15:08:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=LZsNz1g2643T5C4XSRUOFENLGN7wpJhY6KJbbUCbXSRcjxKymzVMj03MzNA7OPTeqI
         4bMHaiBHj2DjbLjMncUEJWF62SVWspIzYFGso9cQmToI/61jaP8ht/zzwVzJHCFlwMz7
         2uq/XGkf/k6CaWhz8FAb5f02bPgZQBYJrOqO4=
MIME-Version: 1.0
Date: Sun, 28 Feb 2010 22:08:37 +0200
Message-ID: <5bdefba51002281208s6f013961red41fcc33e030336@mail.gmail.com>
Subject: Is automatic enumeration of DM devices at boot possible?
From: Ilari Stenroth <ilari.stenroth@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm wondering if kernel could enumerate DM devices automatically at
boot and add them to /dev. It would be useful to enable booting from
root fs on LVM partition without having initramfs. Maybe together with
CONFIG_DEVTMPFS that could be made possible. Or maybe not?

--
Ilari Stenroth
