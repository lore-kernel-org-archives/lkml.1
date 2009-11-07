Return-Path: <linux-kernel-owner+w=401wt.eu-S1751117AbZKGGSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751117AbZKGGSe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 01:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750914AbZKGGSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 01:18:33 -0500
Received: from mail-iw0-f180.google.com ([209.85.223.180]:45656 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbZKGGSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 01:18:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=PFUWWmyNPvZUJZe/IOKv4W3syCEOQ8lMNLO7+pxZ525Y0iav1aQgrRSDhdILOT0O48
         0nsWASwY0T+W8l56G5ksYfkP6Tiu8YNN7kXPIEP4eulBb7HggJ8qF4NReTnxZmJ3S/eu
         tA3Uzqmj1cgPhFt/VeVTCmtZ/xCI1OqeIAATo=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 6 Nov 2009 22:18:18 -0800
Message-ID: <43e72e890911062218o67e32d9ckdda62ff896b9d1cb@mail.gmail.com>
Subject: Stable compat-wireless 2.6.32-rc6 released
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Along with the 2.6.32-rc6 comes the stable compat-wireless based [1]
on it [2] which allows you to get the 2.6.32-rc6 wireless subsystem
and new wireless drivers compilable and installed on older kernels.
This is like the general compat-wireless releases but are *stable* and
should be *stable*. Please report any issues ASAP. For details on
changes you can refer to the ChangeLog-2.6.32-rc6-wireless [3].

  Luis

[1] http://wireless.kernel.org/en/users/Download/stable
[2] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.32/compat-wireless-2.6.32-rc6.tar.bz2
[3] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.32/ChangeLog-2.6.32-rc6-wireless
