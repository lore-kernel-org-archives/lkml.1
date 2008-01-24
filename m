Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585AbYAXTec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbYAXTec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:34:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbYAXTeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:34:21 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46514 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbYAXTeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:34:21 -0500
Message-Id: <20080124193341.166753833@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 24 Jan 2008 20:33:41 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 00/26] mount options: fix filesystem's ->show_options
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Would you please consider these patches for -mm?  They should be
relatively uncontroversial and straightforward fixes.

They touch a lot of filesystems though, so not sure about the
logistics...

For the description, see first patch's header.

Thanks,
Miklos

--
