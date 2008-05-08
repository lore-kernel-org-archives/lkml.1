Return-Path: <linux-kernel-owner+w=401wt.eu-S1756651AbYEHP0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbYEHP0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 11:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbYEHP01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 11:26:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:30628 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbYEHP00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 11:26:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=user-agent:date:from:to:cc:subject:message-id;
        b=nDmxy6LBaJAkZ2HN/UkdhtyW5NWUbfzgYgHWsmsx5mfuHwljZJN7LuWt0xKZsYBjkQ3PQAw5UoER6WkbBFkuYLlGlEaAZYuhH4WM39pWnGxsVV3aGN4aoAPNYX+p/comgoynsiN1Nn/RNO+7/+n+sdA+ithrEIxHyMH7/g+PcFY=
User-Agent: quilt/0.46-1
Date: Thu, 08 May 2008 19:07:56 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [patch 0/2] x86 cleanup - use processor-flags.h
Message-ID: <48231b9f.0405560a.12eb.fffff2f0@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial changes to use predefined flags from processor-flags.h
Please review

		- Cyrill -

-- 
