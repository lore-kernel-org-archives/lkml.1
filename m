Return-Path: <linux-kernel-owner+w=401wt.eu-S1761035AbYDBVBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761035AbYDBVBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758083AbYDBVBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:01:08 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:44624 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392AbYDBVBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:01:06 -0400
Subject: Re: [patch 01/10] vfs: add path_create() and path_mknod()
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080402201321.062856131@szeredi.hu>
References: <20080402201247.358430231@szeredi.hu>
	 <20080402201321.062856131@szeredi.hu>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 14:00:58 -0700
Message-Id: <1207170058.23710.38.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-02 at 22:12 +0200, Miklos Szeredi wrote:
> This series is a cleanup, as well as fixing several places (mostly in
> nfsd) where mnt_{want,drop}_write() were missing.

Could you elaborate on these?

-- Dave

