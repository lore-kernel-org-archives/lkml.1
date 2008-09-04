Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbYIDHnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbYIDHnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 03:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbYIDHnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 03:43:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:29302 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbYIDHnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 03:43:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=g4Wgf4v+iF5gyhu0dwt0271gcqBAM02KvN371+BjRsi5BpvkrGu6u7AtzORpFu5+Qw
         2uA8mv7pfB5M/svbRe8cedFWkmKXpMcC7RPrh6kWMClliWYwM2mno3bD7GxgwQm8yiEb
         q3Bzh2QNUcYE3vFC3/zN9Zz136pZfSNx2cql8=
Message-ID: <38b2ab8a0809040043g7f944872l47f84c53bb213829@mail.gmail.com>
Date: Thu, 4 Sep 2008 09:43:10 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: qestion about I2C_CLASS_HWMON flag
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm wondering why does this flag exist ?

Why is a hw monitor device so special so that an I2C bus needs
a flag to tell the rest of the world that it support it ?

Thanks
-- 
Francis
