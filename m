Return-Path: <linux-kernel-owner+w=401wt.eu-S1753397AbZDGHqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbZDGHqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 03:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbZDGHqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 03:46:07 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:35315 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbZDGHqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 03:46:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=LQXVJgg0ktnmtWmOoue3UnBulPV9tGknztPXAUoCD9m0MYOY3+sXtiNLjw1nDFgDO+
         LpX6LTGRrU3t+kbfZXKn0uMaM+1sYN9QtEu+rJwiJn7V3wkkWVphoXLkCViY8yqe2W76
         1KrF4kSFyn4r+qlUwcORsqhB4NQXstUT9E3Ow=
MIME-Version: 1.0
Date: Tue, 7 Apr 2009 09:45:38 +0200
Message-ID: <8db1092f0904070045l1249fcc4x394dcf286ea6456a@mail.gmail.com>
Subject: [2.6.29-git14] FATAL: Error inserting dm_mod...: Invalid module 
	format
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During boot I can't mount encrypted partitions:

http://unixy.pl/maciek/download/kernel/2.6.29-git14/laptop/dm/img_0003.jpg

2.6.29-git12 works OK.

Config:
http://unixy.pl/maciek/download/kernel/2.6.29-git14/laptop/dm/config-2.6.29-git14.txt

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
