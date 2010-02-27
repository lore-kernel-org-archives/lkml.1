Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030200Ab0B0Qv7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:51:59 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968594Ab0B0Qv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:51:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=dJwmGsGrVakd9rsPCIUG3R7UZXwABDVsom47dxTARqOOmPbDCSC8w9Ux2RemZGRVQN
         FuOdBZ2hULvBInQmOneX4AvMRYCfdCJVob3x7B94HkyM6vkwLpeEjLdgXUJNY/tWyvt0
         MJ77DB4TWbk4HXt/P52A3Hu+i1thgTx2f0hZs=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Subject: Some simple Checkpatch.pl cleanup
Date: Sat, 27 Feb 2010 17:50:41 +0100
Message-Id: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
    here's some simple Checkpatch.pl cleanup.
    They apply and compile on latest Linus' git tree¹ as well
    as on next-20100226.

Thanks a lot for your work,
Andrea

--------------------------
¹ 06a79b82b2a3e4bebb9a20638ca208c780e9e507
