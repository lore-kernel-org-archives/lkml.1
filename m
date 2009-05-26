Return-Path: <linux-kernel-owner+w=401wt.eu-S1759115AbZEZWZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759115AbZEZWZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759121AbZEZWYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:24:13 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:55553 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758950AbZEZWYM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:24:12 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [TuxOnIce-devel] [RFC] TuxOnIce
Date: Wed, 27 May 2009 00:24:38 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Nigel Cunningham <nigel@tuxonice.net>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0905261754250.11998-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0905261754250.11998-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905270024.39073.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 26. Mai 2009 23:56:16 schrieb Alan Stern:
> Probably the driver's author just never got around to adding support
> for suspend/resume.  Which driver is it?  What happens if you don't
> rmmod it?

cxusb. Indeed it does not implement suspend/resume.

	Regards
		Oliver

