Return-Path: <linux-kernel-owner+w=401wt.eu-S1763696AbYDOUCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763696AbYDOUCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 16:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbYDOUCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 16:02:43 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:37203 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042AbYDOUCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 16:02:42 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: "Lev A. Melnikovsky" <melnikovsky@mail.ru>
Subject: Re: ehci-hcd affects hda speed
Date: Tue, 15 Apr 2008 22:02:17 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Rene Herman <rene.herman@keyaccess.nl>,
       Alessandro Suardi <alessandro.suardi@gmail.com>,
       David Brownell <david-b@pacbell.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.00.0803050036210.31935@nev.ubzr> <47E1B062.4060709@keyaccess.nl> <alpine.LFD.1.10.0804152220560.6429@nev.ubzr>
In-Reply-To: <alpine.LFD.1.10.0804152220560.6429@nev.ubzr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804152202.18358.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 15. April 2008 21:56:24 schrieb Lev A. Melnikovsky:
> The oddest peculiarity for me is the hysteretic difference between #1 and 
> #3 states. I mean experimental data (hda throughput) depends not on the 
> state (hardware/loaded modules), but on the path we followed.

Did you compile with CONFIG_USB_SUSPEND?

	Regards
		Oliver

