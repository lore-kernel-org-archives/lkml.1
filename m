Return-Path: <linux-kernel-owner+w=401wt.eu-S1757662AbYCMV2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662AbYCMV2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 17:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbYCMV1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 17:27:55 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51624 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821AbYCMV1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 17:27:51 -0400
Message-Id: <20080313212641.989467982@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 13 Mar 2008 22:26:41 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: viro@zeniv.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 0/6] vfs: mountinfo update
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here are several updates to the /proc/<pid>/mountinfo patch by Ram and
me.  These hopefully address all comments by you, Al and others.

Thanks,
Miklos

--
