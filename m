Return-Path: <linux-kernel-owner+w=401wt.eu-S1762063AbXF0VYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762063AbXF0VYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 17:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309AbXF0VYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 17:24:08 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:5060 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbXF0VYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 17:24:07 -0400
Date: Wed, 27 Jun 2007 23:24:07 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Marc Perkel <mperkel@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: NVidia Driver Support - 1680x1050 mode
Message-ID: <20070627212407.GA26615@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Marc Perkel <mperkel@yahoo.com>, linux-kernel@vger.kernel.org
References: <fc94aae90706262226p417ed77ex97dd20f9bec46e25@mail.gmail.com> <964847.10954.qm@web52510.mail.re2.yahoo.com> <fc94aae90706270718o1704822csea1371a780ca5d23@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc94aae90706270718o1704822csea1371a780ca5d23@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Or use the same hardware as me (and debian)-- and read on my home page how
I got things working :p

hikaru:/usr/lib>dpkg -l | grep nvidia
ii  nvidia-glx									 100.14.11-0          NVIDIA binary Xorg driver
ii  nvidia-glx-dev								 100.14.11-0          NVIDIA binary Xorg driver development files
ii  nvidia-kernel-2.6-amd64							 100.14.11+beta       NVIDIA binary kernel module for 2.6 series c
ii  nvidia-kernel-2.6.18-4-amd64						 100.14.11+beta       NVIDIA binary kernel module for Linux 2.6.18
ii  nvidia-kernel-2.6.22-rc5-agp1-188e1f81ba31af1b65a2f3611df4c670b092bbac-amd64 100.14.11+beta       NVIDIA binary kernel module for Linux 2.6.22

-- 
Carlo Wood <carlo@alinoe.com>

PS I use two of my Samsung SyncMaster 205BW (1650x1050) as dual head
   on an ASUS EN8600 GTS (dual-head). You need nvidia's beta drivers
   (>= 100.14.06) for that to work though.

