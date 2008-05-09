Return-Path: <linux-kernel-owner+w=401wt.eu-S1764290AbYEIQTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764290AbYEIQTb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 12:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbYEIQTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 12:19:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:10324 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213AbYEIQTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 12:19:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=jdTS1pjfbPA0t6tAt0rvEeSKJbxDy7KxzZUNVzgd/E3R+7JfAiicEc1KU2DNcYN3QB/GoQ0SW09Z/4jXaiaHMRELhsWOfxWsaOtPGzkn5NUsP9Hn2jQeRDcKQ4YzqVnQQfJEh/7DSdxikI2fbt99lXYSX/cyAcq+RgtTIXYUzpo=
Message-ID: <85e7c2fc0805090919v613fb823m8dd979b8cd959889@mail.gmail.com>
Date: Sat, 10 May 2008 00:19:11 +0800
From: "Bob Zhang" <zhanglinbao@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Does anyone run AXFS in 2.4 version of kernel ? I am trying my best to apply AXFS patches into 2.4.18
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AXFS is a XIP file system , compared with linear XIP CRAMFS , it is
better in efficiency and speed .

Anyone is doing this work ? Can you share with me ?

Thanks ,

Currently , I have compiled AXFS_inode.c successfully , and compiling
the AXFS_super.c , I feel that maybe I can be successful .Good luck .


Best Regards,
Bob
