Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbYCZXSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbYCZXSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 19:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbYCZXSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 19:18:06 -0400
Received: from gw.goop.org ([64.81.55.164]:46097 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758AbYCZXSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 19:18:04 -0400
Message-ID: <47EAD9A7.6020609@goop.org>
Date: Wed, 26 Mar 2008 16:17:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: what's the incompatibility between hibernation and hotplug memory
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed that Kconfig warns that hibernation and hotplug memory are not 
compatible.  What's the issue?

Thanks,
    J
