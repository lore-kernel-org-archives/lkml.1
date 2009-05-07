Return-Path: <linux-kernel-owner+w=401wt.eu-S1759485AbZEGIKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759485AbZEGIKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 04:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbZEGIKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 04:10:12 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:32453 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759286AbZEGIKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 04:10:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=Y/aDOqz5QeLwk4Fb7lkpTAxUgiYWX0J3S2iSqL1/7JXUXjk1IiWic9VIxYfIUbM2ri
         dwF7gBDTni5hfJWZoQEAKDYMMvPoh+cepp30cmGw1QuiJA+ii8qOevpT04uuH7qzv7oM
         /ImKvK+inZkT3VO0g3FkVWRTKaWSgo9gYP4TU=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 7 May 2009 01:09:50 -0700
Message-ID: <43e72e890905070109m9c75ea3jc4eda264ba9aaa1@mail.gmail.com>
Subject: [ANN] Linux wireless backports page and release for 2.6.30-rc4
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The stable kernel series Linux wireless backports was announced a
couple of weeks ago [1]. These will keep on moving forward and to
follow them you can subscribe to the respective new wiki page for this
[2]. The latest release (just uploaded) is for 2.6.30-rc4:

http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.30/compat-wireless-2.6.30-rc4.tar.bz2

I've actually tested this on 2.6.27 with both ath5k and ath9k.

  Luis

[1] http://marc.info/?l=linux-wireless&m=123915293222504&w=2
[2] http://wireless.kernel.org/en/users/Download/stable
