Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbYCLNZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbYCLNZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 09:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbYCLNZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 09:25:40 -0400
Received: from main.gmane.org ([80.91.229.2]:54024 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbYCLNZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 09:25:39 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Benny Amorsen <benny+usenet@amorsen.dk>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Wed, 12 Mar 2008 14:25:16 +0100
Message-ID: <m3d4q08477.fsf@ursa.amorsen.dk>
References: <200803092346.17556.phillips@phunq.net> <200803110450.19390.phillips@phunq.net> <20080311215601.GM23784@marowsky-bree.de> <200803111602.53835.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: hd5b9080a.c45-01-12.sta.perspektivbredband.net
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
Cancel-Lock: sha1:yAJOIL1qkUX++XMbTN/6GTvFwu4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips <phillips@phunq.net> writes:

> It is ranked high, nonetheless I perceive this spate of sky-is-falling
> comments as low level FUD.  Which of the following do you think is the
> least reliable component in your transactional system:
>
>   1) Linux
>   2) The computer
>   3) The hard disk
>   4) The battery
>   5) The fan

Everyone who has write cache turned on for their hard drives is
running in a mode similar to ramback anyway (except for when the file
system is set to force writes to the platter, but that is rare).
Admittedly, software crashes rarely cause the write cache to be lost,
but hardware failures do, practically every time.

Sure, for some things you don't turn write cache on, and for those you
probably don't use ramback. For the rest, ramback looks very enticing.


/Benny


