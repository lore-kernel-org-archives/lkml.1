Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbYASVmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbYASVmU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 16:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbYASVmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 16:42:08 -0500
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:50966 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbYASVmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 16:42:07 -0500
Date: Sat, 19 Jan 2008 23:42:33 +0200 (MET DST)
From: Szabolcs Szakacsits <szaka@ntfs-3g.org>
X-X-Sender: szaka@dhcppc1
To: Miklos Szeredi <miklos@szeredi.hu>
cc: util-linux-ng@vger.kernel.org, akpm@linux-foundation.org,
       hch@infradead.org, serue@us.ibm.com, viro@ftp.linux.org.uk,
       kzak@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [patch] util-linux-ng: unprivileged mounts support
In-Reply-To: <E1JGKMY-00033X-FF@pomaz-ex.szeredi.hu>
Message-ID: <Pine.LNX.4.61.0801192306420.4482@dhcppc1>
References: <E1JF7Xh-0003q3-Qv@pomaz-ex.szeredi.hu> <Pine.LNX.4.61.0801191745520.4482@dhcppc1>
 <E1JGKMY-00033X-FF@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 19 Jan 2008, Miklos Szeredi wrote:
> 
> But 'fusermount -u /tmp/test' does work, doesn't it?

You're submitting patches to get rid of fusermount, aren't you?

Most users absolutely have no idea what fusermount is and they would 
__really__ like to see umount(8) working finally. 

	Szaka

--
NTFS-3G:  http://ntfs-3g.org


