Return-Path: <linux-kernel-owner+w=401wt.eu-S1760898AbZBMV4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760898AbZBMV4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 16:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbZBMVyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 16:54:16 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:59512 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbZBMVyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 16:54:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:user-agent:date:from:to:cc:subject;
        b=J17j+WceKk4qh700DsjyYhgG9e/k1yBVgVjqSLb0mAFZEwWh9P3SB3MU5wJgT7PZiR
         ZVgL15bBYnYqGhenzarc6DZDNatrb/kgxcG+k20apbaRN7Rq1Np/Ngo0fo0D9j+8TgiT
         TQU5f2eVgjQVsoBT4UjCtf5tZfWv3UnBKDCDQ=
Message-Id: <20090213215017.959278111@gmail.com>
User-Agent: quilt/0.47-1
Date: Sat, 14 Feb 2009 00:50:17 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, hpa@zytor.com, heukelum@fastmail.fm
Cc: linux-kernel@vger.kernel.org
Subject: [RFC 0/6] x86 tip asm ENTRY,ENDPROC cleanup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is a small series of cleanups for assembler
files. Not sure if introducing new GLOBAL macro
was a good idea but code got shorter form of
writting.

Please review. Any comments are highly appreciated.

Cyrill
