Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbYCNLl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbYCNLl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 07:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYCNLlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 07:41:50 -0400
Received: from main.gmane.org ([80.91.229.2]:53055 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbYCNLlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 07:41:49 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Benny Amorsen <benny+usenet@amorsen.dk>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Fri, 14 Mar 2008 12:41:31 +0100
Message-ID: <m3fxutcz2s.fsf@ursa.amorsen.dk>
References: <200803092346.17556.phillips@phunq.net> <200803110450.19390.phillips@phunq.net> <20080311215601.GM23784@marowsky-bree.de> <200803111602.53835.phillips@phunq.net> <m3d4q08477.fsf@ursa.amorsen.dk> <20080312133001.1668f40d@the-village.bc.nu> <20080314093019.GA5966@ucw.cz> <47DA5C8D.2020207@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: hd5b9080a.c45-01-12.sta.perspektivbredband.net
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
Cancel-Lock: sha1:vfRBYKjedfn208oD3/SdE9IQ3kE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ric Wheeler <ric@emc.com> writes:

> The only really safe default is to disable the write cache by default
> or possibly dynamically disable the write cache when barriers are not
> supported by a drive. Both have a severe performance impact and I am
> not sure that for most casual users it is a good trade.

So people ARE running their disks in a mode similar to Ramback.


/Benny


