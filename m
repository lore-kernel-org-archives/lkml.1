Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbYKMRig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbYKMRig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 12:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYKMRi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 12:38:27 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:39561 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbYKMRi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 12:38:26 -0500
Date: Thu, 13 Nov 2008 09:36:16 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, v4l-dvb-maintainer@linuxtv.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       video4linux-list@redhat.com
Subject: Re: linux-next: Tree for November 13 (v4l2 build error)
Message-Id: <20081113093616.a3308a7e.randy.dunlap@oracle.com>
In-Reply-To: <20081113183316.3601c13d.sfr@canb.auug.org.au>
References: <20081113183316.3601c13d.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.491C6595.009D:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008 18:33:16 +1100 Stephen Rothwell wrote:

linux-next-20081113/drivers/media/video/v4l2-ioctl.c: In function '__video_do_ioctl':
linux-next-20081113/drivers/media/video/v4l2-ioctl.c:1819: warning: format '%d' expects type 'int', but argument 3 has type 'struct v4l2_fract'
linux-next-20081113/drivers/media/video/v4l2-ioctl.c:1819: warning: format '%d' expects type 'int', but argument 4 has type 'struct v4l2_fract'
linux-next-20081113/drivers/media/video/v4l2-ioctl.c:1819: warning: format '%d' expects type 'int', but argument 5 has type 'struct v4l2_fract'

---
~Randy
