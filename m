Return-Path: <linux-kernel-owner+w=401wt.eu-S1754983AbZKMByp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbZKMByp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 20:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754903AbZKMByn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 20:54:43 -0500
Received: from mail-iw0-f178.google.com ([209.85.223.178]:32865 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbZKMBym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 20:54:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=JOUlY2wFa7zeVuYx8VXhZ6NzwlRNVaYZaAVFtGmX4bgATkvpJKvq/kIJ/hqQ56elUb
         jpEr9/jVEJz4TMsJLBQlmHDLkcyGjwQ8goPCOKNvwgYfG5o5W+U3UjdBk0sWIe3Z4H4l
         FJTu9qs4YgYAup5BbhphRmXjYqcgxrxZSi8+4=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 12 Nov 2009 17:54:28 -0800
Message-ID: <43e72e890911121754p751060b1h1cec7eeb78da8806@mail.gmail.com>
Subject: [ANN] Stable compat-wireless 2.6.32-rc7 released
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Along with the 2.6.32-rc7 comes the stable compat-wireless based [1]
on it [2] which allows you to get the 2.6.32-rc7 wireless subsystem
and new wireless drivers compilable and installed on older kernels.
This is like the general compat-wireless releases but are *stable* and
should be *stable*. Please report any issues ASAP. For details on
changes you can refer to the ChangeLog-2.6.32-rc7-wireless [3].

 Luis

[1] http://wireless.kernel.org/en/users/Download/stable
[2] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.32/compat-wireless-2.6.32-rc7.tar.bz2
[3] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.32/ChangeLog-2.6.32-rc7-wireless
