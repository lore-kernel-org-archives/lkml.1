Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbZFVHUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbZFVHUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 03:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbZFVHUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 03:20:10 -0400
Received: from mail-px0-f202.google.com ([209.85.216.202]:57240 "EHLO
	mail-px0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbZFVHUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 03:20:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=CjCJxyB+KCb3GlwO+Y+Ipb+NrYjRzOplYozoFbh0b0ILlLHNDHj8Dm4xRl+LiW8Kb9
         JZvuLL5sNZ5COCWKRtmvyRhr9UKkhrzvILQbimF1fFSSBTpVhRT3cJdiradCPYej3UDi
         RVStYiqIEGGTdkX4KduebbSwzG3W9HLchIz6w=
MIME-Version: 1.0
Date: Mon, 22 Jun 2009 12:50:11 +0530
Message-ID: <e31d15d70906220020y70f0daf9k4650d96c402fdf7a@mail.gmail.com>
Subject: PF_RING for n/w traffic more than 1 Gbps
From: Deepak Vishwakarma <vishwakarma.deepak@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI,

PF_RING kernel patch not optimized for traffic handling more than 1
Gbps. I am facing packet overrun over 1 Gbps with linux 2.6.30 patched
with PF_RING.

Does any one has achieved more than 2-3 Gbps packet handling with or
without PF_RING.

Regards,
Deepak
