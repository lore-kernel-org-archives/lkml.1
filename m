Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbZG2Q1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbZG2Q1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 12:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754510AbZG2Q1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 12:27:33 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:55427 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbZG2Q1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 12:27:32 -0400
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jul 2009 12:27:31 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=aTCX3KVA5RcHAerZCOzfTJ/AwgEXcKuvlLanPSL+7HLGL+so9WHKXuXiRzQzTdUzeU
         dtOWiKHaImZUPguS50dSsfxgjeeYQHpR5JtLfhRjjpoMI9P7fT4/wV4vY6Y49uh8ggwl
         loudsPaYUBRVQEO2C9DbApssUg3HzfBVqZuuo=
MIME-Version: 1.0
Date: Wed, 29 Jul 2009 12:21:49 -0400
Message-ID: <194f62550907290921h89d6e7fjad427816b07dcdd4@mail.gmail.com>
Subject: User-space traffic shaper?
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I would like to use an embedded device as traffic shaper (Nokia 770),
unfourtunatly the wlan driver is a binary blob so I am stuck with
2.6.16.27.
As soon as I enable "QoS and/or fair queueing" the device doesn't boot
anymore, however tun/tap seems to work fine.

Are there are traffic-shapers that work in userspace?

Thank you in advance, Clemens
