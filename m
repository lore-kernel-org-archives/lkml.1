Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbZGOLQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbZGOLQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 07:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbZGOLQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 07:16:59 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:55633 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbZGOLQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 07:16:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=YKtxf6aQB7XBsnD8KKtiOc6qZVypOFuAoBEzQ0NOCnCbKWXXWV+fGv72mzH0yAdC73
         +NlP2gLUpDKW40/pOzwgl+4tR8PM/j3uOdzHqaiReZ/NTN4z3U5is5udgErH09n6UXS5
         rq37kr/0TK+wqJ2/6eEa0V5qKjhm2e3kFptzQ=
MIME-Version: 1.0
Date: Wed, 15 Jul 2009 13:11:21 +0200
Message-ID: <c384c5ea0907150411i3523e751tfdf469acce0b2c55@mail.gmail.com>
Subject: Why does NILFS2 hide under Miscellaneous filesystems?
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

just wondering, any reasons why NILFS2 is one of the miscellaneous
filesystems and, for example, btrfs, is not in Kconfig?

Regards,
-- 
Leon
