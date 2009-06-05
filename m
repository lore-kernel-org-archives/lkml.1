Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884AbZFETF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbZFETF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 15:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbZFETFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 15:05:16 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:17683 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbZFETFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 15:05:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=txDZdaS1B4byowdHIMdLFRWS8RxjAV56+L6OYjoPhsJAj+nTbzpyQ6hGHi1UkUE4lc
         zkOFK1vMbn0HYDXTSdqiiH9Pi7h1E7OPA1YsjEuzpHmtfgdR9F1Ne81HU73dgDpYrGEi
         KysX/1Zk4a9ANM+1kZieRuY76wuiQZhxYUNIQ=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 5 Jun 2009 12:04:55 -0700
Message-ID: <43e72e890906051204q22278e4cw6beeae27da50e988@mail.gmail.com>
Subject: [ANN] Atheros 802.11n USB firmware source code released
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, otus-devel@venema.h4ckr.net,
       David Woodhouse <dwmw2@infradead.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm pleased to announce we have released the source code to our
Atheros 802.11n USB Otus/ar9170 device under the GPL. You can grab the
source, compile and use it with the upstream ar9170 device driver.
Patches are welcomed. The git tree available for this is at:

http://git.sipsolutions.net/ar9170-fw.git

For more information please visit the home page for this project is on
our Linux wireless wiki:

http://wireless.kernel.org/en/users/Drivers/ar9170.fw

The ar9170 device driver home page is at:

http://wireless.kernel.org/en/users/Drivers/ar9170

I'd like to thank Johannes Berg and Christian Lamparter for their
incredible contributions to the project both firmware and ar9170
driver so far without which this would not have been possible.

  Luis
