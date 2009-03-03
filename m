Return-Path: <linux-kernel-owner+w=401wt.eu-S1756769AbZCCBh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbZCCBh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 20:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbZCCBhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 20:37:15 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:33140 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbZCCBhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 20:37:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fooaIzr//Af/KDTyGx3Cql4h38SJ9+StaKrnQSnNQrhMTTQ+mZBURG/2ylIAYURpvT
         htVz+BogQVvG3HgBSGOiNhDafpJnygT5FEbi1H6PeGwuVocFf8fEgpbcS8khczRzyKZI
         l6KtUmLTl/OSpc09rKQLtBpaOB00cdIg76EwY=
MIME-Version: 1.0
Date: Mon, 2 Mar 2009 17:37:11 -0800
Message-ID: <43e72e890903021737v7f5c4f06lb13e4f5d3ad67fd7@mail.gmail.com>
Subject: hid-dummy.ko Input/output error -- causing huge delays
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FATAL: Error inserting hid_dummy
(/lib/modules/2.6.29-rc6-wl/kernel/drivers/hid/hid-dummy.ko):
Input/output error

I remember reading a thread where you said this was non-fatal and that
hid-dummy.ko would go away. On my system, every now in a blue moon the
above causes a huge delay during the bootup sequence. I'm talking
about a full 1-2 minute delay. Why is the delay so sporadic?

  Luis
