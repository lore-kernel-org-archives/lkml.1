Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbZGOHjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbZGOHjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 03:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbZGOHjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 03:39:13 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:49086 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbZGOHjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 03:39:10 -0400
Message-ID: <4A5D8797.10004@petalogix.com>
Date: Wed, 15 Jul 2009 09:39:03 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       lkml <linux-arch@vger.kernel.org>
Subject: asm-generic pgtable.h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

I found that we should simplify pgtable.h. There are a lot of generic
functions which use
all archs. Have you look at it or not?

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

