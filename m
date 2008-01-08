Return-Path: <linux-kernel-owner+w=401wt.eu-S1760250AbYAHPsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250AbYAHPsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 10:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759154AbYAHPsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 10:48:01 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:22324 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247AbYAHPsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 10:48:00 -0500
X-SBRS: None
X-MesageID: 36856966
X-Ironport-Server: ftlpip02.citrite.net
X-Remote-IP: 216.142.71.134
X-Policy: $Relay
X-IronPort-AV: E=Sophos;i="4.24,258,1196658000"; 
   d="scan'208";a="36856966"
Date: Tue, 8 Jan 2008 15:47:18 +0000
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, util-linux-ng@vger.kernel.org,
       akpm@linux-foundation.org, hch@infradead.org, serue@us.ibm.com,
       viro@ftp.linux.org.uk, ebiederm@xmission.com, kzak@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: util-linux-ng: unprivileged mounts support
Message-ID: <20080108154718.GH4222@implementation.uk.xensource.com>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Mike Frysinger <vapier@gentoo.org>,
	Miklos Szeredi <miklos@szeredi.hu>, util-linux-ng@vger.kernel.org,
	akpm@linux-foundation.org, hch@infradead.org, serue@us.ibm.com,
	viro@ftp.linux.org.uk, ebiederm@xmission.com, kzak@redhat.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	containers@lists.osdl.org
References: <E1JCCyk-0002pY-AM@pomaz-ex.szeredi.hu> <200801081031.06826.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200801081031.06826.vapier@gentoo.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger, le Tue 08 Jan 2008 10:31:04 -0500, a écrit :
> with all the non-linux changes that have gone in, does there need to be header 
> checks here and then have mount.c key off of them ?  i'm thinking so ...

Sure!

Samuel
