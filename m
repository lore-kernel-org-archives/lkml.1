Return-Path: <linux-kernel-owner+w=401wt.eu-S1757068AbZLNTn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068AbZLNTn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 14:43:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756918AbZLNTn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 14:43:28 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:40438 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756859AbZLNTn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 14:43:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=IjYsS0BRRGHy9zLFljABVDC6WBrw+lQPDQwoK8+x4NOYK0yfaDoGpa3tABq5qZCb9p
         jwWDI3+GBQvRXlOc7BtNq8MhsfTMpN7JQJTnAW/lItcGB0eqEvx3gtAfqXwSdkdBAXUS
         iqihWC5y9N+h3kJdRw3yUB+rkekhlfBfd7VUI=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 14 Dec 2009 11:43:06 -0800
Message-ID: <43e72e890912141143r465247cfn78ebba0c37d73c05@mail.gmail.com>
Subject: Compat-wireless for 2.6.32.1
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a heads up I see 2.6.32.1 was just released but I see no wireless
updates in the changes [1] so not making a respective compat-wireless
release. I expect some changes will be made for 2.6.32.2 though.

[1] http://paste.pocoo.org/show/156996/

  Luis
