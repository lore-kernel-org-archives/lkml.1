Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab0BVPyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 10:54:14 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:53315 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab0BVPyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 10:54:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=okwADlymkHp+txvzozUyKbDPnexaHsXY3aXqR7CWHdPWll5Owq5iwLxVFzd0aSO0kr
         27i6rEMhmKsRd3fLZ1vCNdIV8EKZzhd8BXwrXBQpSOW5cQsDSdXELFO9Wji4/MlMoD39
         L3NFoPx/6FLkNJmd10VP2V55FN64HNwitfrYI=
MIME-Version: 1.0
Date: Mon, 22 Feb 2010 21:24:09 +0530
Message-ID: <29820bf41002220754g32463236gace768157ae76c0b@mail.gmail.com>
Subject: Is NET_KEY (native IPSec stack in Linux) asynchronous?
From: hiren joshi <joshihirenn@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am planning to use NET_KEY (the Linux IPSec stack) with hardware
acceleration cards that let me offload operations related to
encryption, crypto digest and compression.
The acceleration card API is asynchronous. I just want to know if
NET_KEY itself is asynchronous so that I can utilize the card properly
by integrating its API with NET_KEY.

Thank you for your time.

Regards,
Hiren
