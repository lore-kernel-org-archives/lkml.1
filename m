Return-Path: <linux-kernel-owner+w=401wt.eu-S1759774AbYHBTlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759774AbYHBTlA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 15:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760854AbYHBTkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 15:40:11 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:9088 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759381AbYHBTkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 15:40:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=kj7egbMmWaggNr9mHdUeklt8sylfzBvTLMTAq6E/HVxcGnPc93uTmxeLF2A6m1AO2S
         HsjEW2R04WsNFavAB8k3V0jFsZsd7vFhN1FKXIQWsOJpD86DoiYM3+2HpQiGfpW5GdEv
         JJWd8fg7Zt8CruxEO3Pgg0C58+4oVFfVh8ySs=
Message-ID: <ee03a2470808021240q23431107vfed7e7744a964a7b@mail.gmail.com>
Date: Sun, 3 Aug 2008 03:40:06 +0800
From: "kou yu" <ckyoog@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: kernel is deadlocked?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem kernel is 2.6.26. And my distribution is Gentoo.

I report a bug about this in bugzilla, which is Bug 11234.
http://bugzilla.kernel.org/show_bug.cgi?id=11234

This problem is too obvious to believe it is true. Am I wrong? Please
help me check whether kernel is wrong or I am wrong.
