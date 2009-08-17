Return-Path: <linux-kernel-owner+w=401wt.eu-S1757675AbZHQShn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675AbZHQShn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 14:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbZHQShm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 14:37:42 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:47933 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbZHQShm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 14:37:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=GoWSCt2uqagmFPD5gJgi8XodILj8uYdqxVLIh0kp5UaPdvbu3s22HL+GVYKPN2RFvj
         PA6ouNIGbxh5/sgsdg4khdSLdvq+UHkRdxtX+UarFiAaAyYmao26v/CGt6kem/VnLv1F
         FnVK4EKcIRkwf5z6D5gFxyqx1oirYWi0e+MZo=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 17 Aug 2009 11:37:20 -0700
Message-ID: <43e72e890908171137v73732ea3g957e574eae3a81d8@mail.gmail.com>
Subject: Existing netlink kernel <--> kernel communication
To: linux-kernel@vger.kernel.org
Cc: Kevin Hayes <kevin@atheros.com>, Jouni Malinen <j@w1.fi>,
       Johannes Berg <johannes@sipsolutions.net>,
       Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Was curious if there are existing use cases of netlink for kernel <-->
kernel communication rather than the typical kernel <--> userspace.
The original RFC 3549 [1] does specify it could have been used for
"intra-kernel messaging", but am just not aware of existing use cases.
A pointer could help.

[1] http://www.faqs.org/rfcs/rfc3549.html

  Luis
