Return-Path: <linux-kernel-owner+w=401wt.eu-S1763346AbXFRNdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763346AbXFRNdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 09:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758443AbXFRNcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 09:32:54 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:48014 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758312AbXFRNcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 09:32:54 -0400
To: dmlb2000@gmail.com
CC: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-reply-to: <9c21eeae0706171428u5a9ff79rad2b2083d3436d7f@mail.gmail.com>
	(dmlb2000@gmail.com)
Subject: Re: [fuse-devel] FS block count, size and seek offset?
References: <9c21eeae0706171428u5a9ff79rad2b2083d3436d7f@mail.gmail.com>
Message-Id: <E1I0HLS-0007lU-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 18 Jun 2007 15:32:38 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> P.S. maybe a posix filesystem interface manual would be good?

Maybe you are looking for this:

  http://www.opengroup.org/onlinepubs/009695399/

Miklos
