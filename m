Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbZKTGc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbZKTGc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 01:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbZKTGcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 01:32:55 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:38532 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbZKTGcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 01:32:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=eYZggKSj8LHZsIaumSpRFdaEZciRPuKF+Z0l4dFjM7zT29zP/a3LESY0gOGahEy2c/
         mGLpq3nPFnFs87QTLDyRUtLnlHhK/i8PCzPthGGpfArEUX1Qr54ivYey+eUZvjV120kH
         +SAjfaUkEzESYTyJxoA94zEByE5DzFcArea1s=
Message-ID: <4B06384C.2080703@gmail.com>
Date: Fri, 20 Nov 2009 14:33:48 +0800
From: "Helight.Xu" <helight.xu@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: =?UTF-8?B?5aaC5L2V6YCa6L+HZmTmib7liLDmiZPlvIDmlofku7bnmoTot6/lvoQ=?=
 =?UTF-8?B?5Y+K5ZCN56ew?=
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在用户程序中打开文件进行编辑，那在内核中如何能通过open后的fd
来找到相应打开文件的路径及其名字呢？

-- 
---------------------------------
Zhenwen Xu - Open and Free
Home Page:	http://zhwen.org

