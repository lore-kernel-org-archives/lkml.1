Return-Path: <linux-kernel-owner+w=401wt.eu-S1761644AbYECKda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761644AbYECKda (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 06:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758960AbYECKdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 06:33:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:57177 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbYECKc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 06:32:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=user-agent:date:from:to:cc:subject:message-id;
        b=GkWAlP1i0nFtG2Ru3eVPz29Uoht5kVHLNHzTi3TVFL9bm16Q2UwjMyH8D4q5NlyEHaHHsTlLq5Gm7QkZteRHJXhDPZuwvmULeRGdbDnYdDyJpnw7xGVUNLFZmi5BQzoozkWzlkC7hRJLtcXQNINIuoghEFbLf3b1az79zuI8VmA=
User-Agent: quilt/0.46-1
Date: Sat, 03 May 2008 14:18:00 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
       ralf@linux-mips.org
Cc: linux-kernel@vger.kernel.org, gorcunov@gmail.com
Subject: [patch 0/4] trivial: use SELFMAG instead of numeric constant
Message-ID: <481c3f58.0637560a.0f85.ffff8140@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series does replace numeric constants with SELMAG.
Please review and comment if possible, especially please check on MIPS.

		- Cyrill -

-- 
