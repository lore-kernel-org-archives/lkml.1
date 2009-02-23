Return-Path: <linux-kernel-owner+w=401wt.eu-S1755623AbZBWUDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbZBWUDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 15:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756275AbZBWUCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 15:02:19 -0500
Received: from mail-fx0-f167.google.com ([209.85.220.167]:38402 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117AbZBWUCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 15:02:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:user-agent:date:from:to:cc:subject;
        b=N6Y/i8Z2YsMvh0DId67rA+MblHoxUZi23+qCJF+zVneXL2/CYu3FBuRgwf9O5+BI9f
         b/PokO9YEZGfX7tK6HRoRQG3Wweaj2vUGCc7XqzrYYduzs0ay0Ku9vgnkMHtcHfIGRLE
         kCzrCsthFJNu+2XBtEbPaI07Ts366EPuOhCKM=
Message-Id: <20090223195656.512422509@openvz.org>
User-Agent: quilt/0.47-1
Date: Mon, 23 Feb 2009 22:56:56 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: hpa@zytor.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: heukelum@fastmail.fm
Subject: [patch 0/6] x86-tip cleanup series
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is a small series of trivial cleanups.

I'm not sure if it's a good idea to bring GLOBALs
into entry_64.S so please check if it really
become forming into better shape
(patch titled x86: head_64.S - use GLOBAL macro)

Please review.

Cyrill

