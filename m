Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbYCMP3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbYCMP3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 11:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbYCMP3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 11:29:36 -0400
Received: from main.gmane.org ([80.91.229.2]:44977 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbYCMP3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 11:29:35 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Benny Amorsen <benny+usenet@amorsen.dk>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Thu, 13 Mar 2008 16:29:01 +0100
Message-ID: <m3lk4my75u.fsf@ursa.amorsen.dk>
References: <200803092346.17556.phillips@phunq.net> <200803110450.19390.phillips@phunq.net> <20080311215601.GM23784@marowsky-bree.de> <200803111602.53835.phillips@phunq.net> <m3d4q08477.fsf@ursa.amorsen.dk> <20080312133001.1668f40d@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: hd5b9080a.c45-01-12.sta.perspektivbredband.net
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
Cancel-Lock: sha1:ey2lQQuLO6dVzyekPo0SCkCACVQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> On the contrary - the hard disk cache is managed by the barrier logic in
> the kernel, and the ordering even on failures is fairly predictable.

Doesn't that require explicitly setting barrier=1 for ext3? Are there
any distributions which set that by default?


/Benny


