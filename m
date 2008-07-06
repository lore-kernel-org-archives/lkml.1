Return-Path: <linux-kernel-owner+w=401wt.eu-S1758706AbYGFQL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706AbYGFQL1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 12:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757247AbYGFQLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 12:11:20 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:3753 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633AbYGFQLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 12:11:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=hzeZHDCxpfMe6FFOqVPAnqm/8Pv73I/Bm8Fb0rwb+UtsFdGd+W3m+LZWMphJm+zhVa
         jcQssb5FNpoIa8rEd2VKKEsHlyVyVYaJAtUECXK36m03LFonaCiq/awQvU76HT0IvlKy
         ksxb/P0AgBkGfn/jrwJHORUCszSs2ZiG41s0w=
Message-ID: <4870EEE2.6060700@gmail.com>
Date: Sun, 06 Jul 2008 12:12:18 -0400
From: Bradley Hanna <brahan.ml@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Does the kernel detect arch features when making config?
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does the kernel detect the specifics of the my computer architecture
when a defconfig is run?

It just seems like when I run defconfig the kernel knows to configure
for a 64 bit system.

What others factor could cause me to make this assumption?

thanks for your patience,

brahan
