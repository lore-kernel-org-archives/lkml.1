Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbYA1WBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbYA1WBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbYA1WBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:01:04 -0500
Received: from an-out-0708.google.com ([209.85.132.242]:22491 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbYA1WBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:01:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=Xq0ju4HoCVaoYm6msQv1m7cuGgW/uk9DhiyojMQDlin33pnm65U39Bv2FRkBkdcwbdz7apQ2qnGmQJ81/iXv7vCBHI3kBspvR91+fYuh2pTWCSRXPJaWJHkjJbLMjhtevCMUGEyydnlqLVI5k2dET9ujBNeI1qHThPHcNZzEKLg=
Message-ID: <479E5082.50208@gmail.com>
Date: Mon, 28 Jan 2008 20:00:34 -0200
From: Gerardo Exequiel Pozzi <djgera@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: chars > 0xa0 not displayed in console since 2.6.24
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Chars are displayed OK in kernels < 2.6.24 (2.6.22.16, 2.6.23.14) with 
the same config.
I booted clean with init=/bin/bash to discard distro (slackware-current) 
problem/incompat, but the problem persist.

This is a know problem?

The dmesg and config are attached.

