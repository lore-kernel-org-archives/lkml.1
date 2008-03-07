Return-Path: <linux-kernel-owner+w=401wt.eu-S1764409AbYCGExv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764409AbYCGExv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 23:53:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbYCGExn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 23:53:43 -0500
Received: from main.gmane.org ([80.91.229.2]:35871 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054AbYCGExm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 23:53:42 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Greg Schafer <gschafer@zip.com.au>
Subject: Re: [PATCH 2.6.24] chroot= as a new kernel parameter
Date: Fri, 07 Mar 2008 15:53:33 +1100
Message-ID: <pan.2008.03.07.04.53.29.34523@zip.com.au>
References: <200803060001.38432.paplociennik@gmail.com> <47CF79E4.3030107@zytor.com> <20080306102712.GE13391@elte.hu> <47D00B16.6040004@zytor.com> <20080306212028.GB1747@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ppp56d0.dsl.pacific.net.au
User-Agent: Pan/0.14.2 (This is not a psychotic episode. It's a cleansing moment of clarity.)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:

> init=/working_distro/lib/ld-linux.so.2 --library-path /working_distro/lib /working_distro/usr/sbin/chroot /working_distro/ /sbin/init

There is another userland solution I have used in the past - pre-init. It
has a few unnecessary bells and whistles but does the job. You can find it
here:

http://www.linuxfromscratch.org/hints/downloads/files/ATTACHMENTS/lfs_next_to_existing_systems/lfs_next_helpers.tar.bz2

Some documentation here:

http://www.linuxfromscratch.org/hints/downloads/files/lfs_next_to_existing_systems.txt

Regards
Greg


