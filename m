Return-Path: <linux-kernel-owner+w=401wt.eu-S1760975AbYBEUkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760975AbYBEUkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:40:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759088AbYBEUkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:40:06 -0500
Received: from smtp1.cc.lut.fi ([157.24.2.30]:48066 "EHLO smtp1.cc.lut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758836AbYBEUkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:40:01 -0500
Date: Tue, 5 Feb 2008 22:39:58 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] x86 mmiotrace: move files into arch/x86/mm/
Message-ID: <20080205223958.2cab8ce3@daedalus.pq.iki.fi>
In-Reply-To: <20080205222807.7b35ef2b@daedalus.pq.iki.fi>
References: <20080127185238.4bcac54b@daedalus.pq.iki.fi>
	<1201660102.8837.9.camel@brick>
	<1201660453.8837.13.camel@brick>
	<20080130200827.322c4f7d@daedalus.pq.iki.fi>
	<20080131150746.GB11996@elte.hu>
	<20080131180253.6c007852@daedalus.pq.iki.fi>
	<20080131081507.5edcde10@laptopd505.fenrus.org>
	<20080203085522.2b63e15b@daedalus.pq.iki.fi>
	<20080203070321.GA8293@elte.hu>
	<20080205222807.7b35ef2b@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As this patch is too big for the list, it can be found at:
http://jumi.lut.fi/~paalanen/scratch/mmio25-b/0004-x86-mmiotrace-move-files-into-arch-x86-mm.patch

The patch is 85 kB and Documentation/SubmittingPatches says I should not
post it to the list if it exceeds 40 kB.

Ingo, I can also send this directly to your email, if you wish.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
