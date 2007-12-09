Return-Path: <linux-kernel-owner+w=401wt.eu-S1753701AbXLIWpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbXLIWpk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 17:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbXLIWpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 17:45:33 -0500
Received: from postfix1-g20.free.fr ([212.27.60.42]:32858 "EHLO
	postfix1-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbXLIWpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 17:45:32 -0500
Date: Sun, 9 Dec 2007 23:43:49 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org, linuxconsole-dev@lists.sourceforge.net
Subject: vcsa and big endian
Message-ID: <20071209224348.GA25292@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org,
	linuxconsole-dev@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On big endian machines, /dev/vcsa stores text/attribute bytes in big
endian order, while it stores them in little endian order on little
endian machines.  Is that expected?

Samuel
