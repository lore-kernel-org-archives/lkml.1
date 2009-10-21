Return-Path: <linux-kernel-owner+w=401wt.eu-S1753480AbZJUN1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbZJUN1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 09:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbZJUN1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 09:27:23 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:41589 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbZJUN1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 09:27:23 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@ucw.cz>, rjw@sisk.pl,
       Alan Stern <stern@rowland.harvard.edu>
Subject: question on the freezer and line disciplines
Date: Wed, 21 Oct 2009 15:29:21 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc9-0.1-default; KDE/4.1.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910211529.22206.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

to which extent does the freezer protect serial drivers
against unthrottle during suspension and throttle during
resumption?

	Regards
		Oliver

