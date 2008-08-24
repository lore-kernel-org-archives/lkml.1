Return-Path: <linux-kernel-owner+w=401wt.eu-S1754231AbYHXUlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbYHXUlV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 16:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbYHXUlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 16:41:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:40642 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbYHXUlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 16:41:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=qabSGYPOKGV2i0+GoR0Iu+Ai6UbLi8nHLeZhR6xkK4a6WmWefnqoCzXNI0MPEkYvRu
         b1Abhp3KDr6xHBvUoAh0FD2a4wAaSvv3XxAuu2mpqOTnit1011VvNMwtKd9E/AzRKYib
         JKU5qhbRv7vsIfrSB/ehq2eUUUS+AcQWjQ5Ks=
Message-ID: <bf8a4c160808241341l61a40093g2d0f368a3a412c62@mail.gmail.com>
Date: Sun, 24 Aug 2008 22:41:11 +0200
From: "Matteo Michelini" <rawlab@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: OpenBSM format
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm working on a kernel patch that encodes auditing events into a
binary format and I'd like to use the OpenBSM format already present
in many unix systems like FreeBSD, MacOS X and Solaris.
Is it possibile to integrate the OpenBSM format into the linux kernel
or are there problems about License and patents?

--
Matteo Michelini (Milan - Italy)
