Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab0CLBWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 20:22:24 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65372 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921Ab0CLBWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 20:22:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=aOnIyyDWX8uQ0EUbhYb7jzEpoVh0vmxpBIwH3vb/nkWMv2+e/VC/FT5lHdsnxKbN6F
         kGIUS7xvsvIqb9y/7nUCi/i7cSrrYU5Am1P82KoB+Qth3erPq2QYayghbzT48AEDn+hW
         LubJTAv7vTZmbAfKrctdBgf/H9y65078Yi9PM=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 11 Mar 2010 17:22:01 -0800
Message-ID: <43e72e891003111722n4b4d5b6crf764dfe357ff8965@mail.gmail.com>
Subject: cfg80211 conversion of all drivers
To: devel@driverdev.osuosl.org
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Staging developers, if you would like to get your hands wet with some
802.11 work, there are some 802.11 drivers which need conversion to
cfg80211. The list is here:

http://wireless.kernel.org/en/developers/todo-list/cfg80211-conversion

Takers are greatly appreciated.

Thanks,

  Luis
