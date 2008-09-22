Return-Path: <linux-kernel-owner+w=401wt.eu-S1754995AbYIVXkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbYIVXkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 19:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbYIVXkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 19:40:04 -0400
Received: from nospam3.slac.stanford.edu ([134.79.18.120]:56574 "EHLO
	nospam3.slac.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbYIVXkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 19:40:03 -0400
X-Greylist: delayed 860 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Sep 2008 19:40:02 EDT
Subject: SPLICE_F_MOVE
From: Remi Machet <rmachet@slac.stanford.edu>
To: Linux Mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 22 Sep 2008 16:25:39 -0700
Message-Id: <1222125940.1313.83.camel@pcds-ts102.slac.stanford.edu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-53.el4_6.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Does anyone know if SPLICE_F_MOVE is obsolete or still in use ?

The documentation says that the flag should be used to tell splice not
to copy the data when moving data to/from a pipe, but I cannot find
anywhere in the kernel where this flag is being used or checked for.

Thanks,

Remi

