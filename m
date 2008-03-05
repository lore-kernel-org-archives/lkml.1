Return-Path: <linux-kernel-owner+w=401wt.eu-S932934AbYCEXCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934AbYCEXCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:02:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757960AbYCEW4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:56:42 -0500
Received: from an-out-0708.google.com ([209.85.132.243]:19151 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765663AbYCEW4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:56:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=Z2+PtsUn8eXh43BqfjuwZhHiTBc9tM3mPGNRxZpRNgxas6ql8dHiq2LymTyerBGfaprVsgvrPVJUCT0GwNU8AjbX22vTjFcAvUIm0kMgWF4akVfJhUp9o7QLj9EMMFcCKl3FiTvsAUJpLbF8WjaO03XE6UkRsMSwTROFyJyF7kg=
Message-ID: <47CF2525.9020304@gmail.com>
Date: Wed, 05 Mar 2008 14:56:37 -0800
From: Artie Ziff <artie.ziff@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>
Subject: make target `headers_install'
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Is headers_install a valid make target? Somone on the kernel irc said it
was true, however when I run "make headers_install":

make: *** No rule to make target `headers_install'.  Stop.

object/goal: I am attempting to install the includes and set up the asm
links (and whatnot), which is one step in a procedure to build a
cross-compile toolchain.

cheers,
az

