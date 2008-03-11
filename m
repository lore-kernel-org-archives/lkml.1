Return-Path: <linux-kernel-owner+w=401wt.eu-S1752506AbYCKXae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbYCKXae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 19:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbYCKXa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 19:30:27 -0400
Received: from phunq.net ([64.81.85.152]:34580 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751046AbYCKXa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 19:30:26 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Tue, 11 Mar 2008 15:30:11 -0800
User-Agent: KMail/1.9.5
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Grzegorz Kulewski <kangur@polcom.net>,
       linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803110450.19390.phillips@phunq.net> <20080311215601.GM23784@marowsky-bree.de>
In-Reply-To: <20080311215601.GM23784@marowsky-bree.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803111630.12093.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the way are you aware that all you have to do is:

   echo 1 >/proc/driver/ramback/<name>

and ramback already runs in the mode you speak of?

Daniel
