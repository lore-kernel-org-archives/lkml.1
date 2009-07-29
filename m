Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbZG2Lka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbZG2Lka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 07:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbZG2Lka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 07:40:30 -0400
Received: from mail-bw0-f221.google.com ([209.85.218.221]:62843 "EHLO
	mail-bw0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbZG2Lk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 07:40:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=p9t4PlLG6bQ2mcZ6a519ljkiBXY1SV+7HWBrQ0qgwPkb8t1ivwx8nyA98Dp7t19/V9
         XieYbUWtfEwCWXauucl+SoUtJg6SxetFt4hiaARz4U4lbC36xnLUlYm//smRAwoetCtq
         J01Q1g3uYqOMnpTnbecm9pYoMyAFbwCeWlxKc=
MIME-Version: 1.0
Date: Wed, 29 Jul 2009 07:40:28 -0400
Message-ID: <194f62550907290440qecb683cy7a4594fd6ebc50eb@mail.gmail.com>
Subject: QoS and/or fair queueing as module?
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I would like to add QoS and/or fair queueing  support to my N770,
without replacing its kernel.
I already installed  a build system identical to what built the
original kernel, and built all the modules under "QoS and/or fair
queueing".

However when I try to load it, I get messages like:
 cls_basic: Unkown symbol unregister_tcf_proto_ops
 cls_basic: Unknown symbol tcf_exts_destroy
....

Is it not possible to add that functionality by inserting modules only?

Thank you in advance, Clemens
