Return-Path: <linux-kernel-owner+w=401wt.eu-S1758312AbZELPrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312AbZELPrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbZELPrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:47:11 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:9078 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbZELPrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:47:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=GeshgjTTXWlt9Bd2riUG8+eJpauJ/8GfwoF0KmjRfreFJVS2GTjW5rL0hi/TjVMeZI
         3l7sfl92UgJVLcDNydPO6Ot8NeBZGjk6HFtZ9ECuLVCf6gIvLU3MyJIbBoQ2lo2/dWx7
         HSKCFGpKbb6vMyb/MDIp4FyJgY16t15gotExA=
MIME-Version: 1.0
Date: Tue, 12 May 2009 21:17:11 +0530
Message-ID: <20aa8c370905120847j4b19175akbdcafc0db2004567@mail.gmail.com>
Subject: Help to edit inode content
From: ranjith kannikara <ranjithkannikara@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I am a computer science engineering student. We have started a project
to make an application to recover deleted files from an ext3
filesystem. For that we have a doubt . Can we edit the inode content?
ie the recovery will be robust if we could edit the inode contents and
give the pointer address manually or through a code. The inode is
being created in the kernel mode and is it possible to edit those
contents if the code is allowed to have the kernel mode permissions..?

Regards
Ranju..
