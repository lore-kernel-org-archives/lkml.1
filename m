Return-Path: <linux-kernel-owner+w=401wt.eu-S1753526AbYIPWm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbYIPWm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 18:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbYIPWmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 18:42:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39120
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751540AbYIPWmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 18:42:19 -0400
Date: Tue, 16 Sep 2008 15:42:13 -0700 (PDT)
Message-Id: <20080916.154213.237157529.davem@davemloft.net>
To: gregkh@suse.de
CC: linux-kernel@vger.kernel.org
Subject: pci warning regression fix
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Greg, please proactively push this patch of your's upstream
as it will kill off a regression list entry:

http://marc.info/?l=linux-kernel&m=121976424221858&w=4

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11439
Subject		: [2.6.27-rc4-git4] compilation warnings
Submitter	: Rufus &amp; Azrael <rufus-azrael@numericable.fr>
Date		: 2008-08-26 9:37 (18 days old)
References	: http://marc.info/?l=linux-kernel&m=121974353815440&w=4
Handled-By	: Greg KH <gregkh@suse.de>
Patch		: http://marc.info/?l=linux-kernel&m=121976424221858&w=4

Thanks.
