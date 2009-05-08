Return-Path: <linux-kernel-owner+w=401wt.eu-S1763642AbZEHT2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763642AbZEHT2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 15:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbZEHT2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 15:28:33 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:58641 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbZEHT2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 15:28:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=LINfFRKxdk6zk48DSanY8bidlbyAFQyOdwIIQqJ5FkMWk3Tba0lqeChjSYU66ijgUS
         eTqLVBvVgyAfKzzKnl35rSXIeDqa4nSFwOvf0InsRSeEakwXSY2+Yv+tnn1rtPbL+oGi
         r1SG8ScPdjw9NvhqBtXtL7IhqC1mAXnG4hN1w=
MIME-Version: 1.0
Date: Fri, 8 May 2009 21:28:32 +0200
Message-ID: <c5bd819b0905081228m4ee6472bhc3968b178f038b9c@mail.gmail.com>
Subject: Linux and LLVM
From: Grozdan <neutrino8@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

First, I'd like to say that I'm not interested in any holy wars,
trolling, ego-boosters, or whatever, and basically want to ask a
simple question and get the views of the Linux developers on it, at
least from those who are interested in answering it or have time to do
so as I know that most kernel devs are very busy :)

Recently, FreeBSD has reported that it's slowly switching from GCC to
LLVM/CLANG for compilers. What are the thoughts of the Linux kernel
devs about this and do they things that it's a good idea to go in the
same direction as FreeBSD (switching over to LLVM)?

Please CC me as I'm not subscribed to this specific mailing list

Thanks :)
