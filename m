Return-Path: <linux-kernel-owner+w=401wt.eu-S1757509AbYFBGud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509AbYFBGud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 02:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbYFBGuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 02:50:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50255
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750788AbYFBGuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 02:50:22 -0400
Date: Sun, 01 Jun 2008 23:50:18 -0700 (PDT)
Message-Id: <20080601.235018.266140984.davem@davemloft.net>
To: marcel@holtmann.org
Cc: hidave.darkstar@gmail.com, arjan@linux.intel.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH] bluetooth: rfcomm_dev_state_change deadlock fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <E5C422A2-82BC-4E9E-B113-835A11AB8CBD@holtmann.org>
References: <20080602014625.GA2893@darkstar.te-china.tietoenator.com>
	<E5C422A2-82BC-4E9E-B113-835A11AB8CBD@holtmann.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>
Date: Mon, 2 Jun 2008 08:15:03 +0200

> Acked-by: Marcel Holtmann <marcel@holtmann.org>

Applied, but I had to add the commit header string to the two SHA ID
commit references.  Please always provide the header line text as well
as the SHA ID when referencing commits because when backporting or
putting the patch into a different tree the SHA ID will be different
and people will have a terrible time trying to find the commits you
are referring to.

Thanks.
