Return-Path: <linux-kernel-owner+w=401wt.eu-S1755048AbZHCM6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbZHCM6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 08:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbZHCM6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 08:58:49 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:50787 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbZHCM6t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 08:58:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:date:x-google-sender-auth:message-id
         :subject:from:to:content-type:content-transfer-encoding;
        b=drZ6AJ5wsVlhnH2w32kVLj/5lvnTtUzpr4pNKh2p5tdNx0RUcrlQw3mH0EO5pg2fBI
         jGPcpfWI5UKEvs9xNL32IxMSqLUiIsbhMPIzlMp4jBgM678p+Be8qd8vXGbRk+2lbd1T
         0rwJnua5TqqDCIYkIB497rQWLxUZfiJwpTTTg=
MIME-Version: 1.0
Reply-To: q-funk@iki.fi
Date: Mon, 3 Aug 2009 15:58:48 +0300
X-Google-Sender-Auth: 966b219433376b48
Message-ID: <11fae7c70908030558r28773beatd1dca702d490a57d@mail.gmail.com>
Subject: x86 Geode issues in kernel >= 2.6.23 and >= 2.6.31-rc4
From: =?UTF-8?Q?Martin=2D=C3=89ric_Racine?= <q-funk@iki.fi>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(non-subscriber post; please keep me in CC)

Greetings,

Having previously reported two issues via Ubuntu's bug tracker and not
found any answer, I thought I'd approach the LKML with the issues at
stake.

1) Since kernel 2.6.23, one cannot boot hardware based on the Geode
SCx200 series. Partial answers about the most plausible cause have
been found by the target hardware's manufacturer as explained at
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/241307

2) Since kernel 2.6.31-rc4, one cannot boot hardware based on the
Geode LX800 as described at
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/396286

In case either of these issues was already reported and there is a
know fix or work-around, I'd love to hear more. Otherwise, please feel
free to contact me for additional details.

-- 
Best Regards,
Martin-Éric
