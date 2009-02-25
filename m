Return-Path: <linux-kernel-owner+w=401wt.eu-S1759620AbZBYJ5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620AbZBYJ5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 04:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757853AbZBYJ5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 04:57:36 -0500
Received: from mtagate2.de.ibm.com ([195.212.17.162]:56436 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761941AbZBYJ5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 04:57:35 -0500
Message-ID: <49A51609.6010902@fr.ibm.com>
Date: Wed, 25 Feb 2009 10:57:29 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] proc_sysctl: use CONFIG_PROC_SYSCTL around ipc and
 utsname proc_handlers
References: <20090224220141.GA30951@us.ibm.com>
In-Reply-To: <20090224220141.GA30951@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> As pointed out by Cedric Le Goater (in response to Alexey's original
> comment wrt mqns), ipc_sysctl.c and utsname_sysctl.c are using
> CONFIG_PROC_FS, not CONFIG_PROC_SYSCTL, to determine whether to define
> the proc_handlers.  Change that.

instead of replying, I should have done the patch my self. thanks serge.

C.
