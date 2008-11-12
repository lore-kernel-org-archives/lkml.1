Return-Path: <linux-kernel-owner+w=401wt.eu-S1756396AbYKLXYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbYKLXYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:24:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbYKLXUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:20:46 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:18912 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472AbYKLXUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:20:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=KxbKGq3JLtlotaXiPk6Bf6YvMX1LJkG/giBv4l8olQLVOSYYH00NlYqiai/+n3r35r
         G0oyXcAjM0tnckIcYZdGpkSmlZASPG5WnuCLgldgeKT3wAcD1hs4halwdvhYK9q1GQDc
         1PtTQsX0M/IctaYM4B5zWpjboNSApiW/xF51M=
Message-ID: <b2cc26e40811121520k711fa702u85e53bbc18b021a0@mail.gmail.com>
Date: Thu, 13 Nov 2008 00:20:44 +0100
From: "Olaf van der Spek" <olafvdspek@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Unix sockets via TCP on localhost: is TCP slower?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Quite often in discussions, I see people claiming Unix sockets are
faster then TCP sockets on a connection that stays inside localhost.
Let's say from app A to app B.
Is this indeed the case and if so, how much and why?
My assumption is that the kernel can optimize the 'connection' and let
any performance differences disappear.

Greetings,

Olaf
